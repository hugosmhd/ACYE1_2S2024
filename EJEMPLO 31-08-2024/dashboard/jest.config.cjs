module.exports = {
    testEnvironment: 'jest-environment-jsdom',
    setupFiles: ['./jest.setup.js'],
    transformIgnorePatterns: ['node_modules/(?!(query-string|decode-uri-component|split-on-first|filter-obj)/)',]
}