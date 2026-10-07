// @ts-check
import { createConfig } from '@swingo/config/eslint/base.mjs';
import { fileURLToPath } from 'node:url';
import { dirname } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));

export default createConfig({ tsconfigRootDir: __dirname });
