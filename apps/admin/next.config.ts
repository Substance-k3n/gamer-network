import type { NextConfig } from 'next';

// Standalone: the Docker image runs .next/standalone without node_modules.
const nextConfig: NextConfig = { output: 'standalone' };

export default nextConfig;
