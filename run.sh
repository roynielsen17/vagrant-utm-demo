#!/bin/sh

# Check if MIGRATIONS flag is set
if [ "$MIGRATIONS" = "true" ]; then
    echo "MIGRATIONS flag is set to true. Running migrations..."
    
    # Run the Alembic migration upgrade command
    python3 -m flask db upgrade 
else
    echo "MIGRATIONS flag is not set or set to false. Skipping migrations."
fi

# Pass control to CMD in Dockerfile to run the Flask app
exec "$@"
