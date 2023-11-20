#include <gb/gb.h>
#include <stdio.h>
#include "splash_screen.h"
#include "splash_screen_tileset.h"

#define TILEMAP_WIDTH_IN_TILES (splash_screen_WIDTH >> 3)
#define TILEMAP_HEIGHT_IN_TILES (splash_screen_HEIGHT >> 3)

void main(void)
{
    SHOW_BKG;
    set_bkg_data(0, splash_screen_tileset_TILE_COUNT, splash_screen_tileset_tiles);
    set_bkg_tiles(0, 0, TILEMAP_WIDTH_IN_TILES, TILEMAP_HEIGHT_IN_TILES, splash_screen_map);

    waitpad(J_START);

    printf("Hello World!");
}
