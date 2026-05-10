import { describe, it, expect } from 'vitest';
import App from './App';

describe('App component', () => {
  it('should be defined', () => {
    expect(App).toBeDefined();
  });

  it('should be a function (React component)', () => {
    expect(typeof App).toBe('function');
  });
});
