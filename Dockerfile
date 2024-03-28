# Use BusyBox as the base image
FROM busybox

# Create a directory to hold application files
WORKDIR /app

# Copy your application files into the container
COPY . .

# Set up any additional configurations or commands
# For example, you might configure environment variables or set up a command to run when the container starts.

# Define the command to run when the container starts (optional)
CMD ["sh"]
