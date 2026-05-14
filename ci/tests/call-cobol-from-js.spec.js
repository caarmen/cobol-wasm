const { test, expect } = require('@playwright/test');

test('answer to life is rendered', async ({ page }) => {
  await page.goto('http://localhost:8080/AnswerToLife.html');

  const text = await page.locator('#text');

  await expect(text).toHaveText(/The answer to life is 42, and 36 for the universe./);
});