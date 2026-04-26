export interface MatchFixture {
  home_team_id: number;
  away_team_id: number;
  round: number;
}

export function generateRoundRobin(teamIds: number[]): MatchFixture[] {
  const teams = [...teamIds];
  if (teams.length % 2 !== 0) teams.push(-1); // bye
  const rounds = teams.length - 1;
  const half = teams.length / 2;
  const fixtures: MatchFixture[] = [];

  for (let round = 0; round < rounds; round++) {
    for (let i = 0; i < half; i++) {
      const home = teams[i];
      const away = teams[teams.length - 1 - i];
      if (home !== -1 && away !== -1) {
        fixtures.push({ home_team_id: home, away_team_id: away, round: round + 1 });
      }
    }
    teams.splice(1, 0, teams.pop()!);
  }
  return fixtures;
}