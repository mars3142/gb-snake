#include <gb/gb.h>
#include <stdint.h>
#include "splash_screen.h"

#define TILEMAP_WIDTH_IN_TILES (splash_screen_WIDTH >> 3)
#define TILEMAP_HEIGHT_IN_TILES (splash_screen_HEIGHT >> 3)

void main()
{
    SHOW_BKG;
    set_bkg_data(0, splash_screen_TILE_COUNT, splash_screen_tiles);
    set_bkg_tiles(0, 0, TILEMAP_WIDTH_IN_TILES, TILEMAP_HEIGHT_IN_TILES, splash_screen_map);
}
