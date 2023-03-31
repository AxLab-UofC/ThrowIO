//save the orange position
void story_saveOrangePosition(float orangex1, float orangey1, float orangex2, float orangey2, int flyToOrange, int dropFruit, int nextOrange) {
  table = new Table();

  table.addColumn("OrangeX1");
  table.addColumn("OrangeY1");
  table.addColumn("OrangeX2");
  table.addColumn("OrangeY2");
  table.addColumn("flyToOrange");
  table.addColumn("dropFruit");
  table.addColumn("nextOrange");

  TableRow newRow = table.addRow();
  newRow.setFloat("OrangeX1", orangex1);
  newRow.setFloat("OrangeY1", orangey1);
  newRow.setFloat("OrangeX2", orangex2);
  newRow.setFloat("OrangeY2", orangey2);
  newRow.setInt("flyToOrange", flyToOrange);
  newRow.setInt("dropFruit", dropFruit);
  newRow.setInt("nextOrange", nextOrange);

  saveTable(table, "../data/position.csv");
}
