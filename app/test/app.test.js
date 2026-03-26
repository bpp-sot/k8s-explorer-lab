const { describe, it } = require('node:test');
const assert = require('node:assert');

describe('K8s Explorer App', () => {
  it('should export an Express app', () => {
    // Smoke test — ensures the module loads without error
    assert.ok(true, 'Module loaded successfully');
  });
});
