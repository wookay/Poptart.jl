# julia -i repo.jl

# https://github.com/wookay/Octo.jl
using Octo.Adapters.PostgreSQL # Repo Schema
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Mouse Button Label Slider didClick

window_title = "Repo"
window1 = Windows.Window(title=window_title, frame=(x=10,y=20,width=200,height=200))
windows = [window1]
app_title = "Octo"
Application(windows=windows, title=app_title, frame=(width=430, height=300))

Repo.connect(
    adapter = Octo.Adapters.PostgreSQL,
    dbname = "postgresqltest",
    user = "postgres",
)

struct Employee
end
Schema.model(Employee, table_name="Employee", primary_key="ID")

Repo.debug_sql()

#=
Repo.execute([DROP TABLE IF EXISTS Employee])
Repo.execute(Raw("""
    CREATE TABLE Employee (
        ID SERIAL,
        Name VARCHAR(255),
        Salary FLOAT(8),
        PRIMARY KEY (ID)
    )"""))
changes = (Name="Tim", Salary=15000.50)
Repo.insert!(Employee, changes)
=#

button = Button(title="Repo.query(Employee)", frame=(width=150, height=30))
put!(window1, button)

didClick(button) do event
    df = Repo.query(Employee)
    show(stdout, MIME"text/plain"(), df)
    println()
end

#Base.JLOptions().isinteractive==0 && wait()
