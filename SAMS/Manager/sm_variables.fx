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

public class sm_variables
{
	public var salesmanager_side_panel : Panel;
	public var index:Integer = 0;
	// Main Panel
	public var saleman_unm_field : TextBox;
	public var saleman_pass_field : PasswordBox;
	public var salesmanager : Panel;
	public var sm_afterlogin:Panel;
	
	//View Previous Sales
	public var sm_prevsales: Panel;
	public var vps_msg;
	public var vps_prod_name: String[];
	public var vps_prod_qty: Integer[];
	public var temp = 0;	
	
	//Assign Target
	public var saleman_assignTarget_choicebox_item: String[];
	public var saleman_assignTarget_error: Boolean = true;
	public var saleman_assignTarget_choicebox : ChoiceBox;
	public var saleman_assignTarget_targetvalue_field : TextBox;
	public var saleman_assigntargetdate : ChoiceBox;
	public var saleman_assigntargetmonth : ChoiceBox;
	public var saleman_assigntargetyear : ChoiceBox;
	public var saleman_assign_targets : Panel;

	//View Targets
	public var tarVal: String[];
	public var tarPerUnm: String[];
	public var tarDueDate: String[];
	public var tarStatus:String[];
	public var lv_target_size:Integer;
	public var viewTargetLabels: ListView;
	public var viewTargetListView: ListView;
	public var sm_view_target : Panel;
	public var lv_target_flag:Boolean = false;
	public var lv_target_ind: Integer;
	
	// Add Company
	public var saleman_addCompany_name_field : TextBox;
	public var saleman_addCompany_phno_field : TextBox;
	public var saleman_addCompany_email_field : TextBox;
	public var saleman_addCompany_address_field : TextBox;
	public var saleman_addCompany_city_field : TextBox;
	public var saleman_addCompany_state_field : TextBox;
	public var saleman_addCompany_country_field : TextBox;
	public var saleman_addCompany: Boolean = true;
	public var saleman_add_company : Panel;
	
	//View Companies
	public var lv_comp_nm:String = "";
	public var lv_comp_phoneno:String = "";
	public var lv_comp_email:String = "";
	public var lv_comp_city:String = "";
	public var lv_comp_state:String = "";
	public var lv_comp_country:String = "";
	public var lv_comp_nm_t:TextBox;
	public var lv_comp_phoneno_t:TextBox;
	public var lv_comp_email_t:TextBox;
	public var lv_comp_city_t:TextBox;
	public var lv_comp_state_t:TextBox;
	public var lv_comp_country_t:TextBox;
	public var lv_comp_upBtn: Button;
	public var lv_comp_flag:Boolean = false;
	public var lv_comp_ind: Integer;
	public var lv_comp_len: Integer = 0;
	public var comp_nm : String[];
	public var comp_phoneno : String[];
	public var comp_email : String[];
	public var comp_city : String[];
	public var comp_state : String[];
	public var comp_country : String[];

	public var lv_comp_size:Integer;
	public var viewCompanyListView: ListView;
	public var viewCompanyLabels: ListView;
	public var salesmanager_view_company : Panel;
	
	//Add Client
	public var saleman_addClient_firstname_field : TextBox;
	public var saleman_addClient_middlename_field : TextBox;
	public var saleman_addClient_lastname_field : TextBox;
	public var saleman_addClient_phoneno_field : TextBox;
	public var saleman_addClient_email_field : TextBox;
	public var saleman_addClient: Boolean = true;
	
	//View Clients
		
	public var lv_cl_nm:String = "";
	public var lv_cl_compnm:String = "";
	public var lv_cl_phoneno:String = "";
	public var lv_cl_email:String = "";	
	public var lv_cl_phoneno_t:TextBox;
	public var lv_cl_email_t:TextBox;
	public var lv_cl_upBtn: Button;
	public var lv_cl_flag:Boolean = false;
	public var lv_cl_ind: Integer;
	public var lv_cl_len: Integer = 0;
	public var cl_email : String[];
	public var cl_phoneno : String[];
	public var cl_nm : String[];
	public var cl_compnm : String[];
	
	public var lv_cl_size:Integer;
	public var viewClientListView: ListView;
	public var viewClientLabels: ListView;
	public var salesmanager_view_client : Panel;
	
	//Add stock
	public var add_stock_product: ChoiceBox;
	public var add_stock_qty: TextBox;
	public var add_stock_item: String[];
	public var add_stock : Boolean = true;
	public var STOCK_PATTERN : String = "^[1-9][0-9]*$";
	public var stockpattern: Pattern = Pattern.compile(STOCK_PATTERN);
	public var salesmanager_add_stock : Panel;
	
	//View stock
	public var lv_stock_flag:Boolean = false;
	public var lv_stock_ind: Integer;
	public var lv_stock_len: Integer = 0;
	public var stock_name: String[];
	public var stock_qty: String[];
	public var viewStockLabels: ListView;
	public var viewStockListView: ListView;
	public var salesmanager_view_stock : Panel;
	public var lv_stock_size:Integer;
	
	//Add Person	
	public var saleman_addsalesperson_fnm_field : TextBox;
	public var saleman_addsalesperson_mnm_field : TextBox;
	public var saleman_addsalesperson_lnm_field : TextBox;
	public var saleman_addsalesperson_unm_field : TextBox;
	public var saleman_addsalesperson_phoneno_field : TextBox;
	public var saleman_addsalesperson_email_field : TextBox;
	public var saleman_addsalesperson_address_field : TextBox;
	public var saleman_field5_xCo:Float = 1;
	public var add_sales_person : Boolean = true;
	public var smimage: BufferedImage;

	//View Person
	
	public var salesmanager_view_person : Panel;
	public var viewPersonListView: ListView;
	public var viewPersonLabels: ListView;
	public var lv_per_flag:Boolean = false;
	public var lv_per_ind: Integer;
	public var sp_name: String[];
	public var sp_unm: String[];
	public var sp_bdate: String[];
	public var sp_dept: String[];
	public var sp_phoneno: String[];
	public var sp_email : String[];
	public var lv_per_size = 0;
	
	//Edit Profile
	
	public var sm_fnm : TextBox;
	public var sm_mnm : TextBox;
	public var sm_lnm : TextBox;
	public var sm_bdate : ChoiceBox;
	public var sm_bmon: ChoiceBox;
	public var sm_byear : ChoiceBox;
	public var sm_phno: TextBox;
	public var sm_email : TextBox;
	public var sm_add: TextBox;
	public var sm_pic: ImageView;
	public var sm_picbtn : Button;
	public var sm_piclbl : Label;
	public var sm_error: Boolean;
	public var sm_edit_profile : Panel;
}