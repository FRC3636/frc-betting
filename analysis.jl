using DataFrames, SQLite, Gadfly

data = DataFrame(DBInterface.execute(SQLite.DB("rankings.db"), "SELECT * FROM rankings;"))

plot(
    data[data.rank.<=20, :],
    x=:rank,
    y=:points,
    color=:year,
    Geom.point,
    Geom.line,
    Scale.color_discrete(),
    Guide.title("District Points by Rank and Year"),
)