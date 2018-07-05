<?xml version="1.0" encoding="UTF-8"?>
<tileset name="lec6-2" tilewidth="64" tileheight="64" tilecount="128" columns="8">
 <image source="lec6-2.png" trans="ff00ff" width="512" height="1024"/>
 <tile id="1">
  <properties>
   <property name="c_d" type="float" value="0.1"/>
   <property name="isWater" type="bool" value="true"/>
   <property name="trigger" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="24">
  <properties>
   <property name="collide" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="56">
  <properties>
   <property name="collide" type="bool" value="true"/>
  </properties>
 </tile>
 <tile id="72">
  <properties>
   <property name="collide" type="bool" value="true"/>
  </properties>
  <objectgroup draworder="index">
   <object id="9" x="0.5" y="1" width="63" height="62.5"/>
  </objectgroup>
 </tile>
</tileset>
