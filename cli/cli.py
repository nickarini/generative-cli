import typer


app = typer.Typer()


@app.command()
def init():
    print("Initiating new Fabric project")


@app.command()
def run():
    print("Starting Fabric server")


if __name__ == "__main__":
    app()