package bd.project.com.database;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SQL_XE {
    //Driverul OJDBC de la Oracle pentru coenctarea la abza de date
    public SQL_XE(){
        try {
            //step1 load the driver class
            Class.forName("oracle.jdbc.driver.OracleDriver");

        } catch (ClassNotFoundException classNotFoundException) {
            classNotFoundException.printStackTrace();
        }
    }

    public List<Map<String, String>> getAddresses() throws SQLException {
        //step2 create  the connection object
        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "dobos", "dobos");

        //step3 create the statement object
        Statement stmt = con.createStatement();

        //step4 execute query
        ResultSet rs = stmt.executeQuery("select * from addresses");

        List<Map<String, String>> listOfAddresses = new ArrayList<>();
        while (rs.next()){
            HashMap<String, String> address = new HashMap<>();
            address.put("address_id", rs.getString("ADDRESS_ID"));
            address.put("street_address", rs.getString("STREET_ADDRESS"));
            address.put("street_number", rs.getString("STREET_NUMBER"));
            address.put("city", rs.getString("CITY"));
            address.put("country", rs.getString("COUNTRY"));
            listOfAddresses.add(address);
        }
        //step5 close the connection object
        con.close();
        return listOfAddresses;
    }

    public List<Map<String, String>> getProducers() throws SQLException {
        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "dobos", "dobos");
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM producers p, addresses adr where p.address_id = adr.address_id");
        List<Map<String, String>> listOfProducers = new ArrayList<>();
        while (rs.next()){
            HashMap<String, String> producer = new HashMap<>();
            producer.put("producer_id", rs.getString("PRODUCER_ID"));
            producer.put("producer_name", rs.getString("PRODUCER_NAME"));
            producer.put("street_address", rs.getString("STREET_ADDRESS"));
            producer.put("street_number", rs.getString("STREET_NUMBER"));
            producer.put("city", rs.getString("CITY"));
            producer.put("country", rs.getString("COUNTRY"));
            listOfProducers.add(producer);
        }
        con.close();
        return listOfProducers;
    }

    public List<Map<String, String>> getPharmacies() throws SQLException {
        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "dobos", "dobos");
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM pharmacies p, addresses adr where p.address_id = adr.address_id");
        List<Map<String, String>> listOfPharmacies = new ArrayList<>();
        while (rs.next()){
            HashMap<String, String> pharmacy = new HashMap<>();
            pharmacy.put("pharmacy_id", rs.getString("PHARMACY_ID"));
            pharmacy.put("pharmacy_name", rs.getString("PHARMACY_NAME"));
            pharmacy.put("street_address", rs.getString("STREET_ADDRESS"));
            pharmacy.put("street_number", rs.getString("STREET_NUMBER"));
            pharmacy.put("city", rs.getString("CITY"));
            pharmacy.put("country", rs.getString("COUNTRY"));
            listOfPharmacies.add(pharmacy);
        }
        con.close();
        return listOfPharmacies;
    }

    public List<Map<String, String>> getDrugs() throws SQLException {
        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "dobos", "dobos");
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(
                "SELECT d.drug_id, d.drug_name, COALESCE(d.description, 'No Description') as description, " +
                        "p.producer_name, adr.street_address, adr.street_number, adr.city, adr.country " +
                        "FROM drugs d, producers p, addresses adr " +
                "where p.address_id = adr.address_id and d.producer_id = p.producer_id");
        List<Map<String, String>> listOfDrugs = new ArrayList<>();
        while (rs.next()){
            HashMap<String, String> drug = new HashMap<>();
            drug.put("drug_id", rs.getString("DRUG_ID"));
            drug.put("drug_name", rs.getString("DRUG_NAME"));
            drug.put("description", rs.getString("DESCRIPTION"));
            drug.put("producer_name", rs.getString("PRODUCER_NAME"));
            drug.put("street_address", rs.getString("STREET_ADDRESS"));
            drug.put("street_number", rs.getString("STREET_NUMBER"));
            drug.put("city", rs.getString("CITY"));
            drug.put("country", rs.getString("COUNTRY"));
            listOfDrugs.add(drug);
        }
        con.close();
        return listOfDrugs;
    }

    public List<Map<String, String>> getLocalDrugs() throws SQLException {
        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "dobos", "dobos");
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(
                "SELECT l.LOCAL_DRUG_ID, d.DRUG_NAME, ph.PHARMACY_NAME, adr.COUNTRY, adr.CITY, l.PRICE, l.EXPIRATION_DATE, l.QUANTITY, prod.PRODUCER_NAME, COALESCE(DESCRIPTION, 'Not Description') as description " +
                        "from local_drugs l inner join drugs d on l.drug_id = d.drug_id inner join pharmacies ph on l.pharmacy_id = ph.pharmacy_id inner join addresses adr on ph.address_id = adr.address_id inner join producers prod on prod.producer_id = d.producer_id");
        List<Map<String, String>> listOfLocalDrugs = new ArrayList<>();
        while (rs.next()){
            HashMap<String, String> localDrug = new HashMap<>();
            localDrug.put("local_drug_id", rs.getString("LOCAL_DRUG_ID"));
            localDrug.put("drug_name", rs.getString("DRUG_NAME"));
            localDrug.put("description", rs.getString("DESCRIPTION"));
            localDrug.put("pharmacy_name", rs.getString("PHARMACY_NAME"));
            localDrug.put("city", rs.getString("CITY"));
            localDrug.put("country", rs.getString("COUNTRY"));
            localDrug.put("price", rs.getString("PRICE"));
            localDrug.put("quantity", rs.getString("QUANTITY"));
            localDrug.put("expiration_date", rs.getString("EXPIRATION_DATE"));
            localDrug.put("producer_name", rs.getString("PRODUCER_NAME"));

            listOfLocalDrugs.add(localDrug);
        }
        con.close();
        return listOfLocalDrugs;
    }

    public List<Map<String, String>> getBills() throws SQLException {
        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "dobos", "dobos");
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(
                "SELECT b.bill_id, MAX(b.issue_date) ISSUE_DATE, SUM(o.quantity * ld.price) TOTAL FROM bills b, orders o, local_drugs ld where " +
                        "o.bill_id = b.bill_id and ld.local_drug_id = o.local_drug_id GROUP BY b.bill_id");
        List<Map<String, String>> listOfBills = new ArrayList<>();
        while (rs.next()){
            HashMap<String, String> bill = new HashMap<>();
            bill.put("bill_id", rs.getString("BILL_ID"));
            bill.put("issue_date", rs.getString("ISSUE_DATE"));
            bill.put("total", rs.getString("TOTAL"));

            listOfBills.add(bill);
        }
        con.close();
        return listOfBills;
    }



    public List<Map<String, String>> getOrders() throws SQLException {
        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "dobos", "dobos");
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(
                "SELECT b.bill_id,  d.drug_name, o.quantity, b.issue_date, ld.price, ld.expiration_date, (o.quantity * ld.price) TOTAL FROM orders o, bills b, local_drugs ld, drugs d, pharmacies ph where o.bill_id = b.bill_id and o.local_drug_id = ld.local_drug_id and ld.pharmacy_id = ph.pharmacy_id and d.drug_id = ld.drug_id ORDER BY o.bill_id ASC");
        List<Map<String, String>> listOfOrders = new ArrayList<>();
        while (rs.next()){
            HashMap<String, String> order = new HashMap<>();
            order.put("bill_id", rs.getString("BILL_ID"));
            order.put("drug_name", rs.getString("DRUG_NAME"));
            order.put("quantity", rs.getString("QUANTITY"));
            order.put("issue_date", rs.getString("ISSUE_DATE"));
            order.put("price", rs.getString("PRICE"));
            order.put("expiration_date", rs.getString("EXPIRATION_DATE"));
            order.put("total", rs.getString("TOTAL"));
            listOfOrders.add(order);
        }
        con.close();
        return listOfOrders;
    }
}
