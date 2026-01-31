// tile_if.sv
// Interfaces y tipos base de Tile (SIN package)

typedef enum logic [1:0] {
  TILE_RESET = 2'b00,
  TILE_IDLE  = 2'b01,
  TILE_RUN   = 2'b10,
  TILE_FAULT = 2'b11
} tile_status_t;

typedef enum logic [1:0] {
  TILE_TENSOR  = 2'b00,
  TILE_VECTOR  = 2'b01,
  TILE_CONTROL = 2'b10
} tile_type_t;
