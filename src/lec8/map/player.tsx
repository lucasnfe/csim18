<?xml version="1.0" encoding="UTF-8"?>
<tileset name="player" tilewidth="8" tileheight="8" tilecount="6" columns="2">
 <image source="../sprites/player.png" trans="ff00ff" width="16" height="24"/>
 <tile id="0" type="Player">
  <properties>
   <property name="isPlayer" type="bool" value="true"/>
   <property name="sprite" value="sprites/player.png"/>
  </properties>
  <objectgroup draworder="index">
   <object id="4" x="0.125" y="0" width="7" height="8"/>
  </objectgroup>
 </tile>
</tileset>
