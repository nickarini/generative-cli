import typer
from fastapi import FastAPI
import uvicorn
from pathlib import Path


# Define version
VERSION = "1.0.0"


# Typer CLI app
cli = typer.Typer()

# FastAPI app
app = FastAPI()


@app.get("/")
def read_root():
    return {"message": "Your Fabric server will appear here"}


@cli.command()
def init():
    print("Initiating new Fabric project")


@cli.command()
def run(host: str = "127.0.0.1", port: int = 8000):
    """
    Runs the FastAPI server.
    """
    module_path = f"{Path(__file__).parent.name}.cli:app"
    typer.echo(f"Starting FastAPI server at http://{host}:{port}")
    uvicorn.run(module_path, host=host, port=port, reload=True)


# Add a callback to the Typer app for global options
@cli.callback()
def main(
    version: bool = typer.Option(
        None,
        "--version",
        callback=lambda value: typer.echo(VERSION) if value else None,
        is_eager=True,
        help="Show the application version and exit.",
    )
):
    """
    A CLI application with Typer and FastAPI.
    """
    pass


if __name__ == "__main__":
    cli()

