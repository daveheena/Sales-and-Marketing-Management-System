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
import javafx.animation.transition.*;
import javafx.animation.*;
import java.util.regex.*;
import java.sql.*;
import java.lang.*;

public class sp_variables
{
	public var salesperson_side_panel : Panel;
	// Main Panel
	
	public var saleper_unm_field : TextBox;
	public var saleper_pass_field : PasswordBox;
		
	public var per_afterlogin : Panel;
	//Add Activity Variables
	
	public var act_type: ChoiceBox;
	public var act_name: TextBox;
	public var act_for: TextBox;
	public var act_date_d: ChoiceBox;
	public var act_date_m: ChoiceBox;
	public var act_date_y: ChoiceBox;
	public var act_detail: TextBox;
	public var act_leader: Label;
	public var act_members: ListView;
	public var act_selected_members: ListView;
	public var actscrollbar : ScrollBar;
	
	public var mem_choicebox_item: String[];
	public var selectedmem_choicebox_item: String[];
	public var mem_selected_item: String;
	public var salesper_rs: ResultSet;
	public var salesper_rs1: ResultSet;
	public var add_activity : Boolean = true;
	public var salesper_add_act : Panel;
	
	// View Activity Variables
	public var lv_activity_size:Integer;
	public var lv_otheractivity_size:Integer;
	public var lv_activity_flag:Boolean = false;
	public var lv_activity_ind: Integer;
	public var v_activity_type: String[];
	public var v_activity_name: String[];
	public var v_activity_date: String[];
	public var v_activity_for: String[];
	public var v_activity_detail: String[];
	public var v_activity_members: String[];
	public var person_view_activities : Panel;
	public var viewActivityListView: ListView;
	public var view_act_year : ChoiceBox;
	public var view_act_fyear : ChoiceBox;
	public var view_act_oyear : ChoiceBox;
	public var view_act_ofyear : ChoiceBox;
	
	// View other activity
	public var lv_otheractivity_flag:Boolean = false;
	public var lv_otheractivity_ind: Integer;
	public var v_otheractivity_type: String[];
	public var v_otheractivity_name: String[];
	public var v_otheractivity_date: String[];
	public var v_otheractivity_for: String[];
	public var v_otheractivity_leader: String[];
	public var v_otheractivity_detail: String[];
	public var v_otheractivity_members: String[];
	public var otherviewActivityListView: ListView;
	
	// View lead
	public var lv_lead_flag:Boolean = false;
	public var lv_lead_ind: Integer;
	public var v_lead_type: String[];
	public var v_lead_date: String[];
	public var v_lead_client: String[];
	public var v_lead_detail: String[];
	public var person_view_leads : Panel;
	public var viewLeadLabels: ListView;
	public var viewLeadListView: ListView;
	public var lv_lead_size:Integer;
	public var view_lead_year : ChoiceBox;
	public var view_lead_fyear : ChoiceBox;
	public var view_lead_oyear : ChoiceBox;
	public var view_lead_ofyear : ChoiceBox;
	
	// View other lead
	public var lv_otherlead_flag:Boolean = false;
	public var lv_otherlead_ind: Integer;
	public var v_otherlead_type: String[];
	public var v_otherlead_person: String[];
	public var v_otherlead_date: String[];
	public var v_otherlead_client: String[];
	public var v_otherlead_detail: String[];
	public var otherviewLeadLabels: ListView;
	public var otherviewLeadListView: ListView;
	public var lv_otherlead_size:Integer;
	
	//Add Lead Variables
	
	public var add_lead_type: ChoiceBox;
	public var add_lead_salesperson: Label;
	public var add_lead_client: ChoiceBox;
	public var add_lead_date: ChoiceBox;
	public var add_lead_month: ChoiceBox;
	public var add_lead_year: ChoiceBox;
	public var add_lead_detail: TextBox;
	public var add_lead_Client_item: String[];
	public var add_lead_Client_rs: ResultSet;
	public var add_lead : Boolean = true;
	public var salesper_add_lead : Panel;
	
	//add new sell variables
	public var add_sell_client: ChoiceBox;
	public var add_sell_product: ChoiceBox;
	public var add_sell_qty: TextBox;
	public var add_sell_totalquantity: Integer = 0;
	public var add_sell_totalqty: Label;
	public var add_sell_Client_item: String[];
	public var add_sell_product_item: String[];
	public var add_sell_Client_rs: ResultSet;
	public var add_sell_product_rs: ResultSet;
	public var SELL_PATTERN : String = "^[01-9]+$"; //new 19-04
	public var sellpattern: Pattern = Pattern.compile(SELL_PATTERN);
	public var add_sell : Boolean = true;
	public var salesper_new_sell : Panel;
	
	//View Target
	public var myTarget: String[];
	public var myDueDate: String[];
	public var viewMyTargetListView:ListView;
	public var salesperson_view_target:Panel;
	public var lv_myTar_size:Integer;
	
	//Edit Profile
	
	public var sp_fnm : TextBox;
	public var sp_mnm : TextBox;
	public var sp_lnm : TextBox;
	public var sp_bdate : ChoiceBox;
	public var sp_bmon: ChoiceBox;
	public var sp_byear : ChoiceBox;
	public var sp_phno: TextBox;
	public var sp_email : TextBox;
	public var sp_add: TextBox;
	public var sp_pic: ImageView;
	public var sp_picbtn : Button;
	public var sp_piclbl : Label;
	public var sp_error: Boolean;
	public var sp_edit_profile : Panel;
} 