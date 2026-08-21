import Fastify, { type FastifyInstance } from "fastify";

export function createApp(): FastifyInstance {
	const app = Fastify({
		logger: true,
	});

	app.get("/health", async () => {
		return { status: "ok", timestamp: new Date().toISOString() };
	});

	return app;
}
