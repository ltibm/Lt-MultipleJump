## Installation
1. Download  **lt_multiplejump.as** and copy to **scripts/plugins** folder.
2. Open your **default_plugins.txt** in **svencoop** folder
  and put in;
```
"plugin"
{
    "name" "Multiple Jump"
    "script" "lt_multiplejump"
    "concommandns" "lt"
}
```
3. Send command **as_reloadplugins** to server or restart server.

## Commands
- usage **as_command lt.mj_enabled 1**
- **lt.mj_enabled**: 0 or 1, Enable or Disable current plugin (default 1).
- **lt.mj_maxjump**: 0 or 999 Set maximum jump count(default 2)
- **lt.mj_adminonly** : 0 or 1 Multijump only for admins (default 0);
- **lt.mj_mjonly** : 0 or 1 Multijump only smj pysc code only (default 1);