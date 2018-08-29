# MyProject

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Webpack Setup

Instead of using phx.digest for assets, I have used Webpack manifest plugin to generate a manifest.json with support
for a new view function `webpack_entrypoint_path` that maps entrypoints of webpack; and supports webpack's digests.

The reason for this is to support chunking done by webpack as javascript files internally point to chunked files and
don't have access to the digests that phoenix creates. Bypassing phoenix for this seems like the easiest and correct way
to do this after talking with the community.

## Docker Setup

Mostly based on [Distillery - Working with Docker](https://hexdocs.pm/distillery/guides/working_with_docker.html), this
provides a `Makefile`. Using `make` you can build docker images for release, or I have also added a custom task to
`release` in order to build a edeliver release in the default folder. You may want to change the release name within the
`Makefile` depending on your `AUTO_VERSION` in edeliver.

for information on available `make` tasks run: `make help`

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
