"""
Ensure database is initialized. Runs `init_db.py` and `run_migration.py` only when tables are missing.

This script uses the project's `database.engine` to check for the presence of a
core table (`users`). If it doesn't exist it will run the initialization and
optional migrations. This is designed to be idempotent and safe to call from
container entrypoints.
"""
import sys
import subprocess
from sqlalchemy import inspect

try:
    # Import the project's engine
    from database import engine
except Exception as e:
    print(f"Failed to import database engine: {e}")
    sys.exit(2)


def main():
    inspector = inspect(engine)
    try:
        has_users = inspector.has_table("users")
    except Exception as e:
        print(f"Database connection error: {e}")
        # Exit with non-zero so the entrypoint can retry
        return 2

    if not has_users:
        print("Users table not found — creating tables now...")
        try:
            subprocess.run([sys.executable, "init_db.py"], check=True)
        except subprocess.CalledProcessError as e:
            print(f"init_db.py failed: {e}")
            return 3

        # Attempt to run migrations (non-fatal)
        try:
            subprocess.run([sys.executable, "run_migration.py"], check=False)
        except Exception as e:
            print(f"run_migration.py encountered an error (ignored): {e}")

        print("Database initialization complete.")
        return 0
    else:
        print("Database already initialized; skipping.")
        return 0


if __name__ == "__main__":
    code = main()
    sys.exit(code)
