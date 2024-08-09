import Config

config :cashier, products_repository: Cashier.Products.StaticRepository

import_config "#{Mix.env()}.exs"
