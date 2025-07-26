DELIMITER $$

CREATE TRIGGER trigger_low_inventory
AFTER UPDATE ON inventory
FOR EACH ROW
BEGIN
    DECLARE reorder_point_value INT;

    SELECT reorder_point INTO reorder_point_value
    FROM products
    WHERE product_id = NEW.product_id;

    IF NEW.quantity < reorder_point_value THEN
        INSERT INTO low_stock_alerts (store_id, product_id, current_qty)
        VALUES (NEW.store_id, NEW.product_id, NEW.quantity);
    END IF;
END$$

DELIMITER ;
