const db_path = ("rankings.db" | path expand)

def main [district: string, year: int] {
    sqlite3 rankings.db "CREATE TABLE IF NOT EXISTS rankings (year INTEGER, district TEXT, team INTEGER, rank INTEGER, points INTEGER, PRIMARY KEY (year, district, team));" ".exit"

    http get -H [X-TBA-Auth-Key $env.TBA_AUTH_KEY] $"https://www.thebluealliance.com/api/v3/district/($year)($district)/rankings"
        | insert year $year
        | insert district $district
        | update team_key { parse "frc{n}" | get 0.n }
        | select year district team_key rank point_total
        | rename year district team rank points
        | into sqlite -t rankings rankings.db
}