import javafx.stage.Stage;
import javafx.stage.Alert;
import javafx.scene.Scene;
import javafx.scene.image.*;
import javafx.scene.control.*;
import javafx.scene.text.*;
import javafx.scene.effect.*;
import javafx.scene.layout.*;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.*;
import javafx.scene.transform.Scale;
import javafx.scene.input.MouseEvent;
import javax.swing.JFileChooser;
import java.io.File;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import javafx.animation.transition.*;
import javafx.animation.*;
import java.util.regex.*;
import java.sql.*;
import java.lang.*;

public class admin_variables
{
	public var admin_side_panel : Panel;
	public var admin : Panel;
	public var admin_afterlogin : Panel;
	public var admin_add_department : Panel;
	public var cn:Connection;
	public var st:Statement;
	public var rs:ResultSet;
	public var rs1: ResultSet;
	public var cs:CallableStatement;
	public var cs1:CallableStatement;

	public var yr:String[];
	public var dept_choicebox_item: String[];
	public var description: String[];
	public var xCo: Float = 1;
	public var matcher: Matcher;
	public var dd:String[];
	public var yy:String[];
	public var leap: String;	
	public var main_side_panel : Panel;
	
	// Main Panel
	public var admin_unm_field : TextBox;
	public var admin_pass_field : PasswordBox;
	public var msg: String = "";
	
	// Add Department Code
	public var admin_addDept_name_field: TextBox;
	public var admin_addDept_desc_field: TextBox;
	public var admin_addDept_error: Boolean = true;

	// View Department
	public var lv_dept_size:Integer;
	public var viewDepartmentListView: ListView;
	public var admin_view_department : Panel;
	
	// Add Designation
	public var admin_addDesig_name_field : TextBox;
	public var admin_addDesig_desc_field : TextBox;
	public var admin_addDesig_error: Boolean = true;
	public var admin_add_designation : Panel;
	
	// View Designation
	public var desig_choicebox_item : String[];
	public var desig_description: String[];
	public var lv_desig_size:Integer;
	public var viewDesignationListView: ListView;
	public var admin_view_designation : Panel;
	
	// Add Product
	public var admin_addProduct_name_field : TextBox;
	public var admin_addProduct_error: Boolean = true;
	public var admin_addProduct_qty : Label;
	public var admin_addProduct : Panel;
	
	// View Product
	public var prod_name: String[];
	public var prod_qty: String[];
	public var lv_prod_nm:String;
	public var lv_prod_qty:String;	
	public var lv_prod_flag:Boolean = false;
	public var lv_prod_ind: Integer;
	public var lv_prod_len: Integer = 0;
	public var lv_prod_size:Integer;
	public var viewProductListView: ListView;
	public var admin_view_product : Panel;
	
	// Add Manager
	public var EMAIL_PATTERN : String;
	public var pattern: Pattern;
	public var PHONE_PATTERN : String;
	public var phonepattern: Pattern;	
	public var admin_addManager_fnm_field : TextBox;
	public var admin_addManager_mnm_field : TextBox;
	public var admin_addManager_lnm_field : TextBox;
	public var admin_addManager_unm_field : TextBox;
	public var admin_addManager_phoneno_field : TextBox;
	public var admin_addManager_email_field : TextBox;
	public var admin_addManager_address_field : TextBox;
	public var admin_addManager_pass_field: PasswordBox;
	public var add_sales_manager: Boolean = true;
	public var image: BufferedImage;
	public var admin_addManager_Malegender : RadioButton;
	public var admin_addManager_Femalegender : RadioButton;
	public var addsalesmanagerbirthyear : ChoiceBox;
	public var addsalesmanagerbirthmonth : ChoiceBox;
	public var addsalesmanagerbirthdate : ChoiceBox;
	public var admin_addManager_deptchoicebox : ChoiceBox;
	public var scrollbar : ScrollBar;
	public var selectedfilelabel : Label;
	public var admin_add_manager : Panel;
	
	// View Manager
	public var lv_man_flag:Boolean = false;
	public var lv_man_ind: Integer;
	public var lv_man_len: Integer = 0;
	public var sm_name: String[];
	public var sm_unm: String[];
	public var sm_bdate: String[];
	public var sm_dept: String[];
	public var sm_phoneno: String[];
	public var sm_email : String[];
	public var lv_man_size:Integer;
	public var viewManagerListView: ListView;
	public var admin_view_manager : Panel;
}