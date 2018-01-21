
item water = to_item("soda water");
item dough = to_item("wad of dough");
item bread = to_item("loaf of soda bread");
item adson = to_item("Adson Martin");

void main(int fuel)
{
    int totalBread = (fuel + 4) / 5;
    int bakeBread = totalBread - bread.item_amount();
    if (bakeBread > 0)
    {
        if (dough.item_amount() < bakeBread)
            buy(bakeBread - dough.item_amount(), dough);
        if (water.item_amount() < bakeBread)
            buy(bakeBread - water.item_amount(), water);
        craft("cook", bakeBread, dough, water);
    }
    cli_execute("asdonmartin fuel " + totalBread + " " + bread.to_string());
}
