import contextlib
import socket
import threading
import time
from http.server import SimpleHTTPRequestHandler
from socketserver import TCPServer
from pathlib import Path

import requests
import unittest


class QuietHandler(SimpleHTTPRequestHandler):
    # Silence default HTTP server logging during tests
    def log_message(self, format, *args):  # noqa: A003 (shadow builtins)
        return


def find_free_port() -> int:
    with contextlib.closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as s:
        s.bind(("127.0.0.1", 0))
        s.listen(1)
        return int(s.getsockname()[1])


class ThreadingHTTPServer(TCPServer):
    allow_reuse_address = True


def start_static_server(root_dir: Path):
    # Use a custom handler bound to the desired directory
    class Handler(QuietHandler):
        def __init__(self, *args, **kwargs):
            super().__init__(*args, directory=str(root_dir), **kwargs)

    port = find_free_port()
    server = ThreadingHTTPServer(("127.0.0.1", port), Handler)

    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()

    base_url = f"http://127.0.0.1:{port}"

    # Wait briefly for readiness
    deadline = time.time() + 3.0
    while time.time() < deadline:
        try:
            requests.get(base_url, timeout=0.25)
            break
        except Exception:
            time.sleep(0.05)

    return server, base_url


def stop_static_server(server: ThreadingHTTPServer) -> None:
    with contextlib.suppress(Exception):
        server.shutdown()
    with contextlib.suppress(Exception):
        server.server_close()


class FrontendSmokeTest(unittest.TestCase):
    def test_frontend_serves_index_and_assets(self):
        project_root = Path(__file__).resolve().parents[1]
        frontend_dir = project_root / "frontend"
        self.assertTrue(frontend_dir.is_dir(), "frontend directory is missing")

        server, base_url = start_static_server(frontend_dir)
        try:
            # Index page
            r = requests.get(base_url + "/", timeout=2)
            self.assertEqual(r.status_code, 200)
            self.assertIn("AlbumGuessr", r.text)  # Title/branding present

            # CSS
            r_css = requests.get(base_url + "/styles.css", timeout=2)
            self.assertEqual(r_css.status_code, 200)
            self.assertIn(":root", r_css.text)

            # JS config
            r_cfg = requests.get(base_url + "/config.js", timeout=2)
            self.assertEqual(r_cfg.status_code, 200)
            self.assertIn("ALGOLIA_CONFIG", r_cfg.text)

            # Data file for game
            r_data = requests.get(base_url + "/mistery-albums.jsonl", timeout=2)
            self.assertEqual(r_data.status_code, 200)
            self.assertGreater(len(r_data.text.strip()), 0)
        finally:
            stop_static_server(server)


if __name__ == "__main__":
    unittest.main()
