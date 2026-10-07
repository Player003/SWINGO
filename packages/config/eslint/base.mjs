// @ts-check
import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import prettierConfig from 'eslint-config-prettier';
import unusedImports from 'eslint-plugin-unused-imports';

/**
 * Base ESLint flat config (ESLint v9) shared across all workspaces.
 *
 * Includes:
 * - @eslint/js recommended
 * - typescript-eslint recommended-type-checked for TypeScript source files
 * - eslint-plugin-unused-imports
 * - eslint-config-prettier (disables rules conflicting with Prettier)
 *
 * @param {object} options
 * @param {string} options.tsconfigRootDir - Absolute path to the package root containing tsconfig.json
 * @returns {import('typescript-eslint').ConfigArray}
 */
export function createConfig({ tsconfigRootDir }) {
  return tseslint.config(
    // Ignore generated/build output and config files that are outside tsconfig scope
    {
      ignores: [
        'dist/**',
        'build/**',
        'node_modules/**',
        'coverage/**',
        '.turbo/**',
        '.next/**',
        '.expo/**',
      ],
    },
    // Apply recommended JS rules to all files
    eslint.configs.recommended,
    // Apply type-checked TS rules only to TypeScript source files
    {
      files: ['**/*.{ts,tsx,mts,cts}'],
      extends: [...tseslint.configs.recommendedTypeChecked],
      plugins: {
        'unused-imports': unusedImports,
      },
      languageOptions: {
        parserOptions: {
          projectService: true,
          tsconfigRootDir,
        },
      },
      rules: {
        // Enforce no explicit any (also covered by @typescript-eslint/no-explicit-any)
        '@typescript-eslint/no-explicit-any': 'error',
        // Remove unused imports automatically
        'unused-imports/no-unused-imports': 'error',
        'unused-imports/no-unused-vars': [
          'warn',
          {
            vars: 'all',
            varsIgnorePattern: '^_',
            args: 'after-used',
            argsIgnorePattern: '^_',
          },
        ],
        // Disable built-in no-unused-vars in favor of unused-imports plugin
        '@typescript-eslint/no-unused-vars': 'off',
        'no-unused-vars': 'off',
      },
    },
    // Disable type-checking rules for .mjs/.cjs config files (not in tsconfig)
    {
      files: ['**/*.{mjs,cjs}'],
      extends: [tseslint.configs.disableTypeChecked],
    },
    prettierConfig,
  );
}
