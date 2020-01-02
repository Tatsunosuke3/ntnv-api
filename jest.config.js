module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  moduleNameMapper: {
    '^~/(.+)': '<rootDir>/src/$1'
  },
  testMatch: [
    "**/*.test.ts"
  ],
  silent: false,
  verbose: false
};