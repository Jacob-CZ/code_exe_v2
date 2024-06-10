import signal
import time
import threading

class GracefulKiller:
    kill_now = False
    def __init__(self):
        signal.signal(signal.SIGINT, self.exit_gracefully)
        signal.signal(signal.SIGTERM, self.exit_gracefully)

    def exit_gracefully(self, signum, frame):
        self.kill_now = True

def main_loop():
    while not killer.kill_now:
        print("Hello, World!")
        time.sleep(1)

if __name__ == '__main__':
    killer = GracefulKiller()
    main_thread = threading.Thread(target=main_loop)
    main_thread.start()
    
    while not killer.kill_now:
        time.sleep(0.1)  # Allow some time for the main thread to run

    print("End of the program. I was killed gracefully :)")
    main_thread.join()