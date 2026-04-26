import { generateRoundRobin } from '../services/fixture.service';

describe('Fixture Service', () => {
  it('should generate correct number of matches for 4 teams', () => {
    const teamIds = [1, 2, 3, 4];
    const fixtures = generateRoundRobin(teamIds);
    // (n * (n-1)) / 2 = (4 * 3) / 2 = 6
    expect(fixtures).toHaveLength(6);
  });

  it('should handle odd number of teams by adding a bye (mocked as -1)', () => {
    const teamIds = [1, 2, 3];
    const fixtures = generateRoundRobin(teamIds);
    // 3 teams + 1 bye = 4 teams equivalent -> 6 matches total, but only matches without -1 are returned
    // Wait, the implementation handles -1 internally.
    // Let's check the implementation again.
    /*
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
    */
    // For 3 teams: rounds = 3 (since teams.length becomes 4)
    // Round 1: [1, 2, 3, -1] -> (1, -1), (2, 3) -> 1 match
    // Round 2: [1, -1, 2, 3] -> (1, 3), (-1, 2) -> 1 match
    // Round 3: [1, 3, -1, 2] -> (1, 2), (3, -1) -> 1 match
    // Total 3 matches. (n * (n-1)) / 2 = (3 * 2) / 2 = 3. Correct.
    expect(fixtures).toHaveLength(3);
  });

  it('should have all teams playing against each other exactly once', () => {
    const teamIds = [1, 2, 3, 4];
    const fixtures = generateRoundRobin(teamIds);
    const pairings = fixtures.map(f => [Math.min(f.home_team_id, f.away_team_id), Math.max(f.home_team_id, f.away_team_id)].join('-'));
    const uniquePairings = new Set(pairings);
    expect(uniquePairings.size).toBe(6);
  });
});
