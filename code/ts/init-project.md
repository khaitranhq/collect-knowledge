# Init Project with Prettier, Eslint

```bash
pnpm install --save-dev eslint @eslint/js @types/eslint__js typescript typescript-eslint eslint-plugin-prettier eslint-config-prettier prettier
```

- `.prettierrc`

```json
{
  "trailingComma": "none",
  "tabWidth": 2,
  "semi": true,
  "singleQuote": true
}
```
* `eslint.config.mjs`
```mjs
// @ts-check

import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import eslintPluginPrettierRecommended from 'eslint-plugin-prettier/recommended';

export default tseslint.config(
  eslint.configs.recommended,
  ...tseslint.configs.recommended,
  eslintPluginPrettierRecommended,
  {
    rules: {
      '@typescript-eslint/no-unused-vars': 'warn'
    }
  }
);
```
