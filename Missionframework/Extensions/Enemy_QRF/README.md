# ENEMY QRF

## DESCRIPTION
- When players capture a tower sector, they can see if there are enemies nearby by checking the map. With this framework, the enemy now has a chance to call for QRF if blufor forces are detected inside a tower's scan radius.
- The tower handles the detection part and checks if there are military bases inside its radius. The QRF group will come from the nearest military base.
- When a player is inside a tower's scan radius, they can open the map and check what military bases are linked to the tower.
- Each tower has its own cooldown (about 30 minutes), so it's not per session, rather per tower associated to that QRF call.
- The players don't receive warnings about incoming QRF units.
- There're some thresholds:
    - Tower not in a QRF cooldown;
    - Enemy readiness >= 25%;
    - Normal to Harder difficulties;
    - Blufor forces count > 3 or blufor vehicles > 0 inside the tower's scan radius;
    - Opfor military bases nearby;
    - Chance (starting with 10%):

    | Chance Checks | Impact |
    | --- | --- |
    | Blufor Size | + |
    | Enemy Readiness | +++ |
    | Military Bases in Range | ++ |

