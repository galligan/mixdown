import { describe, expect, it } from 'vitest';

describe('Basic test setup', () => {
  it('should work with basic assertions', () => {
    expect(1 + 1).toBe(2);
  });

  it('should handle async tests', async () => {
    const result = await Promise.resolve(42);
    expect(result).toBe(42);
  });
}); 