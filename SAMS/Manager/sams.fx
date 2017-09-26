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
import javafx.geometry.*;
import javafx.scene.input.KeyEvent;
import java.sql.*;
import java.lang.*;
import sm_variables.*;
import admin_variables.*;
import sp_variables.*;
import javafx.date.DateTime;
import java.text.SimpleDateFormat;
import javafx.scene.chart.PieChart;

var sm_vars = new sm_variables();
var admin_vars = new admin_variables();
var vars = new sp_variables();
var filechooser = new JFileChooser();
var matcher: Matcher;
var vps_i: String;
var vps_j: Integer;			
var vps_dat;
var piechart;				
for(l in [2013..2020])
{
    insert l.toString() into admin_vars.yr;
}

try
{
	Class.forName("oracle.jdbc.driver.OracleDriver");
	admin_vars.cn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:sams","scott","tiger");
	admin_vars.st = admin_vars.cn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
}
catch(e:SQLException)
{
	println(e.toString());
}
catch(ex : ClassNotFoundException)
{
     ex.printStackTrace();
}
function removeLastChar(str: String)
{
	var string;
	if(str != "")
	{
		string = str.substring(0, str.length()-1);
	}
	else
	{
		string = str;
	}
	return string;
}


admin_vars.rs1 = admin_vars.st.executeQuery("select Name,Description from DEPT_MASTER");
while(admin_vars.rs1.next())
{
	insert admin_vars.rs1.getString(1).toString() into admin_vars.dept_choicebox_item;							
	insert admin_vars.rs1.getString(2).toString() into admin_vars.description;	
}

//Side Panels

var main_side_panel : Panel = Panel
{
	content :
	[
		Panel
		{
			content:
			[
					Hyperlink
					{
						text: "Manager"
						layoutX: 30;
						layoutY: 120;
						action: function()
						{
							sm_vars.salesmanager.visible = true;   
							img1.visible = false;
							img2.visible = false;
							sm_vars.saleman_unm_field.text = "";
							sm_vars.saleman_pass_field.text = "";							
							admin_vars.msg = "";
						}
					}					
				]
			}
	]
	visible:true;
}

// Sales Manager Side Panel

function salesmanager_sidepanel_visiblefalse()
{
	sm_vars.saleman_assign_targets.visible = false;
	sm_vars.saleman_add_company.visible = false;
	saleman_add_client.visible = false;
	scrollbar2.visible = false;
	saleman_add_saleperson.visible = false;
	sm_vars.salesmanager_view_person.visible = false;
	sm_vars.salesmanager_view_company.visible = false;
	sm_vars.salesmanager_view_client.visible = false;
	sm_vars.sm_edit_profile.visible = false;
	sm_vars.sm_view_target.visible = false;
	sm_vars.salesmanager_add_stock.visible = false;
	sm_vars.salesmanager_view_stock.visible = false;
	sm_vars.sm_afterlogin.visible = false;
	sm_vars.sm_prevsales.visible = false;
}

function assigntarget_value_null()
{
	sm_vars.saleman_assignTarget_choicebox.clearSelection();
	sm_vars.saleman_assigntargetdate.clearSelection();
	sm_vars.saleman_assigntargetmonth.clearSelection();
	sm_vars.saleman_assigntargetyear.clearSelection();
	sm_vars.saleman_assignTarget_targetvalue_field.text = "";
}

function addcompany_value_null()
{
	sm_vars.saleman_addCompany_name_field.text = "";
	sm_vars.saleman_addCompany_phno_field.text = "";
	sm_vars.saleman_addCompany_email_field.text = "";
	sm_vars.saleman_addCompany_address_field.text = "";
	sm_vars.saleman_addCompany_city_field.text = "";
	sm_vars.saleman_addCompany_state_field.text = "";
	sm_vars.saleman_addCompany_country_field.text = "";
}

function addclient_value_null()
{
	sm_vars.saleman_addClient_firstname_field.text = "";
	sm_vars.saleman_addClient_middlename_field.text = "";
	sm_vars.saleman_addClient_lastname_field.text = "";
	sm_vars.saleman_addClient_phoneno_field.text = "";
	sm_vars.saleman_addClient_email_field.text = "";
	saleman_addClient_choicebox.clearSelection();
}

function addsalesperson_value_null()
{
	sm_vars.saleman_addsalesperson_fnm_field.text = "";
	sm_vars.saleman_addsalesperson_mnm_field.text = "";
	sm_vars.saleman_addsalesperson_lnm_field.text = "";
	sm_vars.saleman_addsalesperson_unm_field.text = "";
	saleman_addsalesperson_pass_field.text = "";
	sm_vars.saleman_addsalesperson_phoneno_field.text = "";
	sm_vars.saleman_addsalesperson_email_field.text = "";
	sm_vars.saleman_addsalesperson_address_field.text = "";
	addsalespersonbirthdate.clearSelection();
	addsalespersonbirthmonth.clearSelection();
	addsalespersonbirthyear.clearSelection();
	saleman_addsalesperson_deptchoicebox.clearSelection();
	selectedfilelabel2.text = "No File Selected.";
}
function add_stock_null()
{
	sm_vars.add_stock_product.clearSelection();
    sm_vars.add_stock_qty.text = "";
}
function checkMonthIndex(str:String): Integer
{
	if(str == "JAN" or str == "Jan")
	{
		sm_vars.index = 1;
	}
	else if(str == "FEB" or str == "Feb")
	{
		sm_vars.index = 2;
	}
	else if(str == "MAR" or str == "Mar")
	{
		sm_vars.index = 3;
	}
	else if(str == "APR" or str == "Apr")
	{
		sm_vars.index = 4;
	}
	else if(str == "MAY" or str == "May")
	{
		sm_vars.index = 5;
	}
	else if(str == "MAY" or str == "May")
	{
		sm_vars.index = 5;
	}
	else if(str == "JUNE" or str == "Jun")
	{
		sm_vars.index = 6;
	}
	else if(str == "JULY" or str == "Jul")
	{
		sm_vars.index = 7;
	}
	else if(str == "AUG" or str == "Aug")
	{
		sm_vars.index = 8;
	}
	else if(str == "SEP" or str == "Sep")
	{
		sm_vars.index = 9;
	}
	else if(str == "OCT" or str == "Oct")
	{
		sm_vars.index = 10;
	}
	else if(str == "NOV" or str == "Nov")
	{
		sm_vars.index = 11;
	}
	else if(str == "DEC" or str == "Dec")
	{
		sm_vars.index = 12;
	}
	return sm_vars.index;
}
sm_vars.salesmanager_side_panel = Panel
{
	content : 
	[
		Panel
		{
			content:
			[
				Hyperlink
				{
						text: "Assign Targets"
						layoutX: 30;
						layoutY: 120;
						action: function()
						{
							salesmanager_sidepanel_visiblefalse();
							sm_vars.saleman_assign_targets.visible = true;
							assigntarget_value_null();
							delete sm_vars.saleman_assignTarget_choicebox_item;
							admin_vars.rs = admin_vars.st.executeQuery("select USERNAME from SALESMAN_MASTER where UNDER='{sm_vars.saleman_unm_field.text}'");
							while(admin_vars.rs.next())
							{
								insert admin_vars.rs.getString(1).toString() into sm_vars.saleman_assignTarget_choicebox_item;							
							}
						}
				}
				Hyperlink
				{
						text: "View Targets"
						layoutX: 30;
						layoutY: 150;
						action: function()
						{
							salesmanager_sidepanel_visiblefalse();
							sm_vars.sm_view_target.visible = true;
							delete sm_vars.tarVal;
							delete sm_vars.tarPerUnm;
							delete sm_vars.tarDueDate;
							delete sm_vars.tarStatus;
							admin_vars.rs1 = admin_vars.st.executeQuery("select * from salesman_master where under='{sm_vars.saleman_unm_field.text}'");
							while(admin_vars.rs1.next())
							{
								insert {admin_vars.rs1.getString(17).toString()} into sm_vars.tarVal;	
								insert {admin_vars.rs1.getString(5).toString()} into sm_vars.tarPerUnm;
								insert "{admin_vars.rs1.getString(19).toString()} {admin_vars.rs1.getString(20).toString()} {admin_vars.rs1.getString(21).toString()}" into sm_vars.tarDueDate;	
								def date = DateTime{}.instant;
								def year = new SimpleDateFormat("YYYY").format(date);
								def month = new SimpleDateFormat("MMM").format(date);
								def day = new SimpleDateFormat("dd").format(date);
								if({admin_vars.rs1.getString(21).toString()} == "")
								{
									delete {admin_vars.rs1.getString(17).toString()} from sm_vars.tarVal;
									delete {admin_vars.rs1.getString(5).toString()} from sm_vars.tarPerUnm;
									delete "{admin_vars.rs1.getString(19).toString()} {admin_vars.rs1.getString(20).toString()} {admin_vars.rs1.getString(21).toString()}" from sm_vars.tarDueDate;
									continue;
								}
								else if(Integer.parseInt({admin_vars.rs1.getString(21).toString()}) > Integer.parseInt(year))
								{
									if({admin_vars.rs1.getString(18)} != "")
									{
										if(Integer.parseInt({admin_vars.rs1.getString(17)}) <= Integer.parseInt({admin_vars.rs1.getString(18)}))
										{
											insert "Achieved" into sm_vars.tarStatus;
										}
										else
										{
											insert "Pending" into sm_vars.tarStatus;
										}
									}
									else
									{
										insert "Pending" into sm_vars.tarStatus;
									}
								}
								else if(Integer.parseInt({admin_vars.rs1.getString(21).toString()}) == Integer.parseInt(year))
								{
									if(checkMonthIndex('{admin_vars.rs1.getString(20).toString()}') == checkMonthIndex(month))
									{
										if(Integer.parseInt({admin_vars.rs1.getString(19).toString()}) <= Integer.parseInt(day))
										{
											if({admin_vars.rs1.getString(18)} != "")
											{									
												if(Integer.parseInt({admin_vars.rs1.getString(17)}) <= Integer.parseInt({admin_vars.rs1.getString(18)}))
												{
													insert "Achieved" into sm_vars.tarStatus;
												}
												else
												{
													insert "Not Achieved" into sm_vars.tarStatus;
												}
											}
											else
											{
												insert "Not Achieved" into sm_vars.tarStatus;
											}
										}
										else
										{
											if({admin_vars.rs1.getString(18)} != "")
											{									
												if(Integer.parseInt({admin_vars.rs1.getString(17)}) <= Integer.parseInt({admin_vars.rs1.getString(18)}))
												{
													insert "Achieved" into sm_vars.tarStatus;
												}
												else
												{
													insert "Pending" into sm_vars.tarStatus;
												}
											}
											else
											{
												insert "Pending" into sm_vars.tarStatus;
											}
										}
									}
									else if(checkMonthIndex('{admin_vars.rs1.getString(20).toString()}') > checkMonthIndex(month))
									{
										if({admin_vars.rs1.getString(18)} != "")
										{									
											if(Integer.parseInt({admin_vars.rs1.getString(17)}) <= Integer.parseInt({admin_vars.rs1.getString(18)}))
											{
												insert "Achieved" into sm_vars.tarStatus;
											}
											else
											{
												insert "Pending" into sm_vars.tarStatus;
											}
										}
										else
										{
											insert "Pending" into sm_vars.tarStatus;
										}
									}
									else
									{
										insert "Not Achieved" into sm_vars.tarStatus;
									}
								}
								else
								{
									if({admin_vars.rs1.getString(18)} != "")
									{									
										if(Integer.parseInt({admin_vars.rs1.getString(17)}) <= Integer.parseInt({admin_vars.rs1.getString(18)}))
										{
											insert "Achieved" into sm_vars.tarStatus;
										}
										else
										{
											insert "Not Achieved" into sm_vars.tarStatus;
										}
									}
									else
									{
										insert "Not Achieved" into sm_vars.tarStatus;
									}
								}								
							}
							sm_vars.lv_target_size = 30 * sm_vars.tarPerUnm.size();
						}
				}
				Hyperlink
				{
						text: "Add Company"
						layoutX: 30;
						layoutY: 180;
						action: function()
						{
							salesmanager_sidepanel_visiblefalse();;
							sm_vars.saleman_add_company.visible = true;
							addcompany_value_null();
						}
			   }
			   Hyperlink
				{
						text: "View Companies"
						layoutX: 30;
						layoutY: 210;
						action: function()
						{
							salesmanager_sidepanel_visiblefalse();
							sm_vars.salesmanager_view_company.visible = true;
							sm_vars.lv_comp_flag = false;
							sm_vars.lv_comp_nm = "";
							sm_vars.lv_comp_phoneno = "";
							sm_vars.lv_comp_email = "";
						}
			   }
			    Hyperlink
				{
						text: "Add Client"
						layoutX: 30;
						layoutY: 240;
						action: function()
						{
							salesmanager_sidepanel_visiblefalse();
							saleman_add_client.visible = true;
							addclient_value_null();
							delete saleman_addClient_choicebox_item;
							var saleman_addClient_rs: ResultSet = admin_vars.st.executeQuery("select C_NAME from COMPANY_MASTER");
							while(saleman_addClient_rs.next())
							{
								insert saleman_addClient_rs.getString(1).toString() into saleman_addClient_choicebox_item;							
							}
						}
				}
				Hyperlink
				{
						text: "View Clients"
						layoutX: 30;
						layoutY: 270;
						action: function()
						{
							salesmanager_sidepanel_visiblefalse();
							sm_vars.salesmanager_view_client.visible = true;
							sm_vars.lv_cl_flag = false;
							sm_vars.lv_cl_email = "";
							sm_vars.lv_cl_phoneno = "";
						}
				}
				Hyperlink
				{
						text: "Add Stock"
						layoutX: 30;
						layoutY: 300;
						action: function()
						{
							salesmanager_sidepanel_visiblefalse();
							sm_vars.salesmanager_add_stock.visible = true;
							add_stock_null();
							delete sm_vars.add_stock_item;
							admin_vars.rs = admin_vars.st.executeQuery("select NAME from PRODUCT_MASTER");
							while(admin_vars.rs.next())
							{
								insert admin_vars.rs.getString(1).toString() into sm_vars.add_stock_item;							
							}
						}
				}
				Hyperlink
				{
						text: "View Stock"
						layoutX: 30;
						layoutY: 330;
						action: function()
						{
							salesmanager_sidepanel_visiblefalse();
							sm_vars.salesmanager_view_stock.visible = true;
							delete sm_vars.stock_name;
							delete sm_vars.stock_qty;
							admin_vars.rs1 = admin_vars.st.executeQuery("select * from product_master");
							while(admin_vars.rs1.next())
							{
								insert {admin_vars.rs1.getString(2).toString()} into sm_vars.stock_name;
								insert {admin_vars.rs1.getString(3).toString()} into sm_vars.stock_qty;
							}
							sm_vars.lv_stock_size = 30 * sm_vars.stock_name.size();

						}
				}
				Hyperlink
				{
						text: "Add Person"
						layoutX: 30;
						layoutY: 360;
						action: function()
						{
							salesmanager_sidepanel_visiblefalse();
							scrollbar2.visible = true;
							saleman_add_saleperson.visible = true;
							addsalesperson_value_null();
						}
				}
				Hyperlink
				{
						text: "View Persons"
						layoutX: 30;
						layoutY: 390;
						action: function()
						{
							salesmanager_sidepanel_visiblefalse();
							sm_vars.salesmanager_view_person.visible = true;
						}
				}
				
				Hyperlink
				{
						text: "View Previous Sales"
						layoutX: 30;
						layoutY: 420;
						action: function()
						{
							salesmanager_sidepanel_visiblefalse();
							sm_vars.sm_prevsales.visible = true;
							sm_vars.vps_msg = "Total Sales";
							delete sm_vars.vps_prod_name;
							delete sm_vars.vps_prod_qty;
							admin_vars.rs = admin_vars.st.executeQuery("select NAME from product_master");
							while(admin_vars.rs.next())
							{
								insert admin_vars.rs.getString(1) into sm_vars.vps_prod_name;
							}
							for(vps_i in sm_vars.vps_prod_name)
							{
								admin_vars.rs1 = admin_vars.st.executeQuery("select * from stock_master where PRODNAME='{vps_i}'");
								while(admin_vars.rs1.next())
								{
									sm_vars.temp = sm_vars.temp + Integer.parseInt({admin_vars.rs1.getString(5)});
								}
								insert sm_vars.temp into sm_vars.vps_prod_qty;
								sm_vars.temp = 0;
								admin_vars.rs1.close();
							}							
							vps_dat = [
							for(vps_i in [0..sm_vars.vps_prod_name.size()])
							{
								PieChart.Data{ label: '{sm_vars.vps_prod_name[vps_i]}' value: Integer.parseInt('{sm_vars.vps_prod_qty[vps_i]}') }
							}
							];							
						}
				}
				Hyperlink
				{
						text: "Edit Profile"
						layoutX: 30;
						layoutY: 450;
						action: function()
						{
							salesmanager_sidepanel_visiblefalse();
							sm_vars.sm_edit_profile.visible = true;
							admin_vars.rs1 = admin_vars.st.executeQuery("select * from salesmanager_master where username='{sm_vars.saleman_unm_field.text}'");
							if(admin_vars.rs1.next())
							{
								sm_vars.sm_fnm.text = "{admin_vars.rs1.getString(2)}";
								sm_vars.sm_mnm.text = "{admin_vars.rs1.getString(3)}";
								sm_vars.sm_lnm.text = "{admin_vars.rs1.getString(4)}";								
								sm_vars.sm_phno.text = "{admin_vars.rs1.getString(12)}";
								sm_vars.sm_email.text = "{admin_vars.rs1.getString(13)}";
								sm_vars.sm_add.text = "{admin_vars.rs1.getString(14)}";
								sm_vars.sm_pic.image = Image{url: "{__DIR__}/userpic/{sm_vars.saleman_unm_field.text}.jpg"};
							}
							sm_vars.sm_byear.clearSelection();
							sm_vars.sm_bmon.clearSelection();
							sm_vars.sm_bdate.clearSelection();
						}
				}
				Hyperlink
				{
						text: "Logout"
						layoutX: 30;
						layoutY: 480;
						action: function()
						{
							salesmanager_sidepanel_visiblefalse();
							sm_vars.salesmanager_side_panel.visible = false;							
							sceneholder = mainscene;
							sm_vars.salesmanager.visible = true;
							sm_vars.saleman_unm_field.text= "";
							sm_vars.saleman_pass_field.text = "";							
							main_side_panel.visible = true;							
							admin_vars.msg = "";
						}
				}
			]
		}
	]
	visible:false;
}
// Manager

//Main Panel

sm_vars.saleman_unm_field = TextBox
{
	columns: 20;
	layoutX: 350;
	layoutY: 100;
	multiline:true;
	lines:1;
	
    onMouseEntered: function(e: MouseEvent):Void
	{
		sm_vars.saleman_unm_field.columns = 30;
		sm_vars.saleman_unm_field.translateX = 10;
	}   
    onMouseExited: function(e: MouseEvent):Void
	{
		sm_vars.saleman_unm_field.columns = 20;
		sm_vars.saleman_unm_field.translateX = 1;
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_pass_field.requestFocus();			
			sm_vars.saleman_unm_field.text = sm_vars.saleman_unm_field.text.trim();
		}		
	}
}
sm_vars.saleman_pass_field = PasswordBox
{
    columns: 20;
    layoutX: 350;
    layoutY: 130;
	transforms:
    [
        Scale {x: bind admin_vars.xCo, y: 1}
    ]
    onMouseEntered: function(e: MouseEvent):Void
    {
		admin_vars.xCo = 1.5;
		sm_vars.saleman_pass_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		admin_vars.xCo = 1;
		sm_vars.saleman_pass_field.translateX = 1;
    }
}
sm_vars.salesmanager = Panel
{
    content :
        [
            Panel
                {
					layoutX: 200,
					layoutY: 100,
					height: 550,
					width: 800
                    content:
                        [
                            Label
                            {
                                text: "Manager";
                                layoutX: 300;
                                layoutY: 40;
                                font:Font.font("ARIAL", FontWeight.BOLD, 20);
                                effect:Glow {level:0.5};
                            }
                            Label
                            {
								id: "label";
                                text: "User Name";
                                layoutX: 240;
                                layoutY: 100;
                            }
                            sm_vars.saleman_unm_field,
                            Label
                            {
								id: "label";
                                text: "Password";
                                layoutX: 240;
                                layoutY: 130;
                            }
                            sm_vars.saleman_pass_field,
                            Button
                            {
                                text: "Log In";
                                layoutX: 350;
								layoutY: 160;
                                transforms:
                                [
                                    Scale {x: 1.2, y: 1.2}
                                ]
                                action: function()
                                {
								
									admin_vars.cs = admin_vars.cn.prepareCall("call manager_login(?,?,?)");
									admin_vars.cs.setString(1,'{sm_vars.saleman_unm_field.text}');
									admin_vars.cs.registerOutParameter(2,Types.VARCHAR);
									admin_vars.cs.registerOutParameter(3,Types.VARCHAR);
									admin_vars.cs.execute();
									
									if(sm_vars.saleman_unm_field.text == "")
									{
										admin_vars.msg = "* Username field cannot be empty";
									}
									else if(admin_vars.cs.getString(2).equals(sm_vars.saleman_unm_field.text))
									{
										if(admin_vars.cs.getString(3).equals(sm_vars.saleman_pass_field.text))
										{
											sm_vars.salesmanager.visible = false;
											main_side_panel.visible = false;
											sceneholder = salesmanager_scene;
											sm_vars.salesmanager_side_panel.visible = true;											
											delete sm_vars.sp_name;
											delete sm_vars.sp_unm;
											delete sm_vars.sp_bdate;
											delete sm_vars.sp_dept;
											delete sm_vars.sp_phoneno;
											delete sm_vars.sp_email;
											admin_vars.rs1 = admin_vars.st.executeQuery("select * from salesman_master where under='{sm_vars.saleman_unm_field.text}'");
											while(admin_vars.rs1.next())
											{												
												insert "{admin_vars.rs1.getString(2).toString()} {admin_vars.rs1.getString(3).toString()} {admin_vars.rs1.getString(4).toString()}" into sm_vars.sp_name;	
												insert {admin_vars.rs1.getString(5).toString()} into sm_vars.sp_unm;
												insert "{admin_vars.rs1.getString(8).toString()}-{admin_vars.rs1.getString(9).toString()}-{admin_vars.rs1.getString(10).toString()}" into sm_vars.sp_bdate;	
												insert {admin_vars.rs1.getString(11).toString()} into sm_vars.sp_dept;
												insert {admin_vars.rs1.getString(12).toString()} into sm_vars.sp_phoneno;
												insert {admin_vars.rs1.getString(13).toString()} into sm_vars.sp_email;
											}
											sm_vars.lv_per_size = 30 * sm_vars.sp_unm.size();
											sm_vars.sm_afterlogin.visible = true;
										}
										else
										{
											admin_vars.msg = "* Username and Password do not match";
										}
									}
									else
									{
										admin_vars.msg = "* Username does not exist"
									}
                                }
                            }
                            Button
                            {
                                text: "Reset";
                                layoutX: 420;
								layoutY: 160;
                                transforms:
                                [
                                    Scale {x: 1.2, y: 1.2}
                                ]
                                action: function()
                                {
                                    sm_vars.saleman_unm_field.text = "";
                                    sm_vars.saleman_pass_field.text = "";
                                }
                            }
							Label
							{
								text: bind admin_vars.msg;
								layoutX: 240;
								layoutY: 200;
								font:Font.font("CALIBRI", FontWeight.REGULAR, 16);
								textFill: Color.RED;
								effect:Glow {level:0.5};
							}
                        ]
                 }
         ]
         visible:false;
}

//After Login
sm_vars.sm_afterlogin = Panel
{
	content : 
	[
		Panel
		{
			layoutX: 200,
			layoutY: 100,
			height: 550,
			width: 800
			content:
			[
				Label
                {
                    text: bind "Welcome {sm_vars.saleman_unm_field.text}";
                    layoutX: 300;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
			]
		}
	]
	visible: false;
}
//View Previous Sales
def vps_date = DateTime{}.instant;
def vps_year = new SimpleDateFormat("YYYY").format(vps_date);
var vps_toyr = ChoiceBox
{
	layoutX: 400;
	layoutY: 450;
	items: [2000..Integer.parseInt('{vps_year}')]
}
var vps_fromyr = ChoiceBox
{
	layoutX: 500;
	layoutY: 450;
	items: [2000..Integer.parseInt('{vps_year}')]
}
piechart = PieChart 
{
	layoutX: 150
	layoutY: 60
	data: bind vps_dat;
};
sm_vars.sm_prevsales = Panel
{
	content : 
	[
		Panel
		{
			layoutX: 200,
			layoutY: 100,
			height: 550,
			width: 800
			content:
			[
				Label
                {
                    text: bind "{sm_vars.vps_msg}";
                    layoutX: 300;
                    layoutY: 40;
                    font:Font.font("ARIAL",FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				piechart,
				Label
                {
                    text: "View Sales of Selected Period";
                    layoutX: 100;
                    layoutY: 450;
					font:Font.font("ARIAL",FontWeight.BOLD, 18);
                }
				vps_toyr,
				vps_fromyr,
				Button
				{
					text:"View"
					layoutX: 600
					layoutY: 450
					action: function()
					{
						if(vps_toyr.selectedIndex == -1 or vps_fromyr.selectedIndex == -1)
						{
							Alert.inform("Select From and To Year Values.");		
						}
						else if(Integer.parseInt(vps_toyr.selectedItem.toString()) > Integer.parseInt(vps_fromyr.selectedItem.toString()))
						{
							Alert.inform("From year must be greater or equal to To year.");
							vps_fromyr.clearSelection();
						}
						else
						{
							delete sm_vars.vps_prod_name;
							delete sm_vars.vps_prod_qty;
							delete vps_dat;
							sm_vars.temp = 0;
							admin_vars.rs = admin_vars.st.executeQuery("select NAME from product_master");
							while(admin_vars.rs.next())
							{								
								insert admin_vars.rs.getString(1) into sm_vars.vps_prod_name;
							}
							for(vps_i in sm_vars.vps_prod_name)
							{
								admin_vars.rs1 = admin_vars.st.executeQuery("select * from stock_master where PRODNAME='{vps_i}'");
								while(admin_vars.rs1.next())
								{
									if(Integer.parseInt('{admin_vars.rs1.getString(8)}') >= Integer.parseInt('{vps_toyr.selectedItem}') and Integer.parseInt('{admin_vars.rs1.getString(8)}') <= Integer.parseInt('{vps_fromyr.selectedItem}'))
									{
										sm_vars.temp = sm_vars.temp + Integer.parseInt({admin_vars.rs1.getString(5)});
									}
								}
								insert sm_vars.temp into sm_vars.vps_prod_qty;
								sm_vars.temp = 0;
								admin_vars.rs1.close();
							}
							sm_vars.vps_msg = "Sales from {vps_toyr.selectedItem} to {vps_fromyr.selectedItem}";
							vps_dat = [
							for(vps_i in [0..sm_vars.vps_prod_name.size()])
							{
								PieChart.Data{ label: '{sm_vars.vps_prod_name[vps_i]}' value: Integer.parseInt('{sm_vars.vps_prod_qty[vps_i]}') }
							}
							];
						}
					}
				}
			]
		}
	]
	visible: false;
}

// Assign Target

sm_vars.saleman_assignTarget_choicebox = ChoiceBox
{
	id: "cb";
	layoutX: 378;
	layoutY: 100;
	scaleX: 1.5;                                        
	items: bind [sm_vars.saleman_assignTarget_choicebox_item];
	layoutInfo: LayoutInfo { width: 100 };
}

sm_vars.saleman_assignTarget_targetvalue_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 350;
	layoutY: 130;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_assignTarget_targetvalue_field.columns = 30;
		sm_vars.saleman_assignTarget_targetvalue_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_assignTarget_targetvalue_field.columns = 20;
		sm_vars.saleman_assignTarget_targetvalue_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.saleman_assignTarget_error == false)
		{
			sm_vars.saleman_assignTarget_targetvalue_field.text = "";
		}
	}
}

sm_vars.saleman_assigntargetdate = ChoiceBox
{
	layoutX: 435;
	layoutY: 190;
	items: bind ["    ",admin_vars.dd];
	disable: bind (sm_vars.saleman_assigntargetmonth.selectedIndex == -1);
}
sm_vars.saleman_assigntargetmonth = ChoiceBox
{
	layoutX: 350;
	layoutY: 190;
	items:["JAN","FEB","MAR","APR","MAY","JUNE","JULY","AUG","SEP","OCT","NOV","DEC"]
	disable: bind (sm_vars.saleman_assigntargetyear.selectedIndex == -1);
	onMouseExited: function(e: MouseEvent): Void
	{
		delete admin_vars.dd;
		if(sm_vars.saleman_assigntargetmonth.selectedItem.toString() == "FEB")
		{
			if(admin_vars.leap == "true")
			{
				for(i in [1..29] )
				{
					insert i.toString() into admin_vars.dd;
				}
			}
			else
			{
				for(i in [1..28] )
				{
					insert i.toString() into admin_vars.dd;
				}
			}
		}
		if(sm_vars.saleman_assigntargetmonth.selectedItem.toString() == "JAN" or sm_vars.saleman_assigntargetmonth.selectedItem.toString() == "MAR" or sm_vars.saleman_assigntargetmonth.selectedItem.toString() == "MAY" or sm_vars.saleman_assigntargetmonth.selectedItem.toString() == "JULY" or sm_vars.saleman_assigntargetmonth.selectedItem.toString() == "AUG" or sm_vars.saleman_assigntargetmonth.selectedItem.toString() == "OCT" or sm_vars.saleman_assigntargetmonth.selectedItem.toString() == "DEC")
		{
			for(i in [1..31] )
			{
				insert i.toString() into admin_vars.dd;
			}
		}
		if(sm_vars.saleman_assigntargetmonth.selectedItem.toString() == "APR" or sm_vars.saleman_assigntargetmonth.selectedItem.toString() == "JUNE" or sm_vars.saleman_assigntargetmonth.selectedItem.toString() == "SEP" or sm_vars.saleman_assigntargetmonth.selectedItem.toString() == "NOV")
		{
			for(i in [1..30] )
			{
				insert i.toString() into admin_vars.dd;
			}
		}
	}
}
sm_vars.saleman_assigntargetyear = ChoiceBox
{
	id: "cb";
	layoutX: 385;
	layoutY: 160;
	scaleX: 1.9;
	items:[admin_vars.yr]
	
	onMouseExited: function(e: MouseEvent): Void
	{
		if(sm_vars.saleman_assigntargetyear.selectedItem.toString() != "")
		{
			var year: Integer = Integer.parseInt(sm_vars.saleman_assigntargetyear.selectedItem.toString());
			if((year mod 4) == 0)
			{
				admin_vars.leap = "true";
			}
			else
			{
				admin_vars.leap = "false";
			}
		}
	}
}
sm_vars.saleman_assign_targets = Panel
{
    content :
        [
            Panel
                {
					layoutX: 200,
					layoutY: 100,
					height: 550,
					width: 800
                    content:
                    [
						Label
						{
							text: "Assign Targets";
							layoutX: 300;
							layoutY: 40;
							font:Font.font("ARIAL", FontWeight.BOLD, 20);
							effect:Glow {level:0.5};
						}
						Label
						{
							id: "label";
							text: "Person";
							layoutX: 240;
							layoutY: 100;
						}
						sm_vars.saleman_assignTarget_choicebox,
						Label
						{
							id: "label";
							text: "Target Value";
							layoutX: 240;
							layoutY: 130;
						}
						sm_vars.saleman_assignTarget_targetvalue_field,
						Label
						{
							id: "label";
							text: "Due Date";
							layoutX: 240;
							layoutY: 160;
						}
						sm_vars.saleman_assigntargetdate,
						sm_vars.saleman_assigntargetmonth,
						sm_vars.saleman_assigntargetyear,
						Button
						{
							text: "Assign";
							layoutX: 350;
							layoutY: 220;
							transforms:
							[
								Scale {x: 1.2, y: 1.2}
							]
							action: function()
							{
								sm_vars.saleman_assignTarget_error = true;
								if(sm_vars.saleman_assignTarget_targetvalue_field.text == "")
								{
									sm_vars.saleman_assignTarget_targetvalue_field.text = "* Target Value cannot be empty.";
									sm_vars.saleman_assignTarget_error = false;
								}
								if(sm_vars.saleman_assigntargetdate.selectedIndex == -1 or sm_vars.saleman_assigntargetmonth.selectedIndex == -1 or sm_vars.saleman_assigntargetyear.selectedIndex == -1 or sm_vars.saleman_assigntargetdate.selectedItem == "    ")
								{
									Alert.inform("Select target due date.");
									sm_vars.saleman_assignTarget_error = false;
								}
								else
								{
									def date = DateTime{}.instant;
									def year = new SimpleDateFormat("YYYY").format(date);
									def month = new SimpleDateFormat("MMM").format(date);
									def day = new SimpleDateFormat("dd").format(date);
									if(Integer.parseInt(sm_vars.saleman_assigntargetdate.selectedItem.toString()) < Integer.parseInt(day) and checkMonthIndex(sm_vars.saleman_assigntargetmonth.selectedItem.toString()) <= checkMonthIndex(month) and sm_vars.saleman_assigntargetyear.selectedItem == year)
									{
										Alert.inform("Past date cannot be entered as Target Due Date");
										sm_vars.saleman_assignTarget_error = false;
									}
								}
								if(sm_vars.saleman_assignTarget_choicebox.selectedIndex == -1)
								{
									Alert.inform("Select Person.");
									sm_vars.saleman_assignTarget_error = false;
								}
								if(sm_vars.saleman_assignTarget_error == true)
								{
									admin_vars.cs1 = admin_vars.cn.prepareCall("call ASSIGN_UPDATE_TARGET(?)");
									admin_vars.cs1.setString(1,'{sm_vars.saleman_assignTarget_choicebox.selectedItem}');
									
									admin_vars.cs = admin_vars.cn.prepareCall("call ASSIGN_TARGET(?,?,?,?,?)");
									admin_vars.cs.setInt(1,Integer.parseInt({sm_vars.saleman_assignTarget_targetvalue_field.text}));
									admin_vars.cs.setString(2,'{sm_vars.saleman_assigntargetdate.selectedItem}');
									admin_vars.cs.setString(3,'{sm_vars.saleman_assigntargetmonth.selectedItem}');
									admin_vars.cs.setString(4,'{sm_vars.saleman_assigntargetyear.selectedItem}');
									admin_vars.cs.setString(5,'{sm_vars.saleman_assignTarget_choicebox.selectedItem}');
									
									admin_vars.cs1.executeUpdate();
									if(admin_vars.cs.executeUpdate() == 0)
									{
										Alert.inform("Target successfully assigned.");
										sm_vars.salesmanager.visible = false;
										main_side_panel.visible = false;
										sm_vars.salesmanager_side_panel.visible = true;
										assigntarget_value_null();
									}
								}
							}
						}
					]
				}
		]
	visible:false;
}
// View Targets

sm_vars.lv_target_size = 30 * sm_vars.tarPerUnm.size();
sm_vars.viewTargetLabels = ListView
{
	layoutInfo: LayoutInfo{width: 520 height: 30}
	layoutX: 130
	layoutY: 100
	visible: bind not (sm_vars.viewTargetListView.height == 0)
	cellFactory: function() {
        var listCell: ListCell = ListCell
		{
			node : HBox {
				content: [
                    VBox {
					layoutInfo: LayoutInfo{width: 150}
			        spacing: 10
                    content: [
                        Label {
							id: "lbl2"
                            text: "Person Name"
                            visible: bind not (sm_vars.viewTargetListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 150}
			        spacing: 10
                    content: [
                        Label {
							id: "lbl2"
                            text: "Due Date"
                            visible: bind not (sm_vars.viewTargetListView.height == 0)
						}
                    ]
					}					
					VBox {
					layoutInfo: LayoutInfo{width: 100}
			        spacing: 10
                    content: [
                        Label {
							id: "lbl2"
                            text: "Target Value"
                            visible: bind not (sm_vars.viewTargetListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 100}
			        spacing: 10
                    content: [
                        Label {
							id: "lbl2"
                            text: "Target Status"
                            visible: bind not (sm_vars.viewTargetListView.height == 0)
						}
                    ]
					}
				]
			}
		}
	}
}
sm_vars.viewTargetListView = ListView {
        items: bind [sm_vars.tarPerUnm]
		layoutInfo: LayoutInfo{height:bind sm_vars.lv_target_size width: 520}
		layoutX: 130
		layoutY: 150
		
        cellFactory: function() {
            var listCell: ListCell;           
			
			if(sm_vars.tarPerUnm.size() > 5)
            {
                sm_vars.lv_target_size = 30 * 5;
            }
            else
            {
                sm_vars.lv_target_size = 30 * sm_vars.tarPerUnm.size();
            }
            listCell = ListCell {
                node : HBox {
					content: [
                         VBox {
							layoutInfo: LayoutInfo{width: 150}
			                spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.tarPerUnm[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_target_flag or not listCell.selected or (sm_vars.lv_target_ind != listCell.index)
                                }                                
                            ]
                        }
                         VBox {
							layoutInfo: LayoutInfo{width: 150}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.tarDueDate[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_target_flag or not listCell.selected or (sm_vars.lv_target_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.tarVal[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_target_flag or not listCell.selected or (sm_vars.lv_target_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.tarStatus[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_target_flag or not listCell.selected or (sm_vars.lv_target_ind != listCell.index)
                                }                  
                            ]
                        }
                        ]
                        }            
            }
        }
        visible:true;
    };
	
sm_vars.sm_view_target = Panel
{
	content : 
	[
		Panel
		{
			layoutX: 200,
			layoutY: 100,
			height: 550,
			width: 800
			content:
			[
				Label
                {
                    text: "Targets";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
				{
					text: "You have not given any targets yet.";
                    layoutX: 220;
                    layoutY: 150;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (sm_vars.viewTargetListView.height == 0)
				}
				sm_vars.viewTargetLabels,
				sm_vars.viewTargetListView,
			]
		}
	]
	visible: false;
}

// Add Company

sm_vars.saleman_addCompany_name_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 375;
	layoutY: 100;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_name_field.columns = 30;
		sm_vars.saleman_addCompany_name_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_name_field.columns = 20;
		sm_vars.saleman_addCompany_name_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.saleman_addCompany == false)
		{
			sm_vars.saleman_addCompany_name_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addCompany_phno_field.requestFocus();
			sm_vars.saleman_addCompany_name_field.text = sm_vars.saleman_addCompany_name_field.text.trim();
		}
	}
}
sm_vars.saleman_addCompany_phno_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 375;
	layoutY: 130;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_phno_field.columns = 30;
		sm_vars.saleman_addCompany_phno_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_phno_field.columns = 20;
		sm_vars.saleman_addCompany_phno_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.saleman_addCompany == false)
		{
			sm_vars.saleman_addCompany_phno_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addCompany_email_field.requestFocus();
			sm_vars.saleman_addCompany_phno_field.text = sm_vars.saleman_addCompany_phno_field.text.trim();
		}
	}
}
sm_vars.saleman_addCompany_email_field = TextBox
{
	columns: 20;
	multiline: true;
	lines:1;
	layoutX: 375;
	layoutY: 160;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_email_field.columns = 30;
		sm_vars.saleman_addCompany_email_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_email_field.columns = 20;
		sm_vars.saleman_addCompany_email_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.saleman_addCompany == false)
		{
			sm_vars.saleman_addCompany_email_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addCompany_address_field.requestFocus();
			sm_vars.saleman_addCompany_email_field.text = sm_vars.saleman_addCompany_email_field.text.trim();
		}
	}
}
sm_vars.saleman_addCompany_address_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 3;
	layoutX: 375;
	layoutY: 190;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_address_field.columns = 30;
		sm_vars.saleman_addCompany_address_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_address_field.columns = 20;
		sm_vars.saleman_addCompany_address_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.saleman_addCompany == false)
		{
			sm_vars.saleman_addCompany_address_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addCompany_city_field.requestFocus();
			sm_vars.saleman_addCompany_address_field.text = sm_vars.saleman_addCompany_address_field.text.trim();
		}
	}
}
sm_vars.saleman_addCompany_city_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 375;
	layoutY: 250;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_city_field.columns = 30;
		sm_vars.saleman_addCompany_city_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_city_field.columns = 20;
		sm_vars.saleman_addCompany_city_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.saleman_addCompany == false)
		{
			sm_vars.saleman_addCompany_city_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addCompany_state_field.requestFocus();
			sm_vars.saleman_addCompany_city_field.text = sm_vars.saleman_addCompany_city_field.text.trim();
		}
	}
}
sm_vars.saleman_addCompany_state_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 375;
	layoutY: 280;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_state_field.columns = 30;
		sm_vars.saleman_addCompany_state_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_state_field.columns = 20;
		sm_vars.saleman_addCompany_state_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.saleman_addCompany == false)
		{
			sm_vars.saleman_addCompany_state_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addCompany_country_field.requestFocus();
			sm_vars.saleman_addCompany_state_field.text = sm_vars.saleman_addCompany_state_field.text.trim();
		}
	}
}
sm_vars.saleman_addCompany_country_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 375;
	layoutY: 310;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_country_field.columns = 30;
		sm_vars.saleman_addCompany_country_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addCompany_country_field.columns = 20;
		sm_vars.saleman_addCompany_country_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.saleman_addCompany == false)
		{
			sm_vars.saleman_addCompany_country_field.text = "";
		}
	}
}
sm_vars.saleman_add_company = Panel
{
    content :
        [
            Panel
                {
					layoutX: 200,
					layoutY: 100,
					height: 550,
					width: 800
                    content:
                    [
						Label
						{
							text: "Add Company";
							layoutX: 300;
							layoutY: 40;
							font:Font.font("ARIAL", FontWeight.BOLD, 20);
							effect:Glow {level:0.5};
						}
						Label
						{
							id: "label";
							text: "Company Name";
							layoutX: 220;
							layoutY: 100;
						}
						sm_vars.saleman_addCompany_name_field,
						Label
						{
							id: "label";
							text: "Company Phone No";
							layoutX: 220;
							layoutY: 130;
						}
						sm_vars.saleman_addCompany_phno_field,
						Label
						{
							id: "label";
							text: "Company E-Mail";
							layoutX: 220;
							layoutY: 160;
						}
						sm_vars.saleman_addCompany_email_field,
						Label
						{
							id: "label";
							text: "Address";
							layoutX: 220;
							layoutY: 190;
						}
						sm_vars.saleman_addCompany_address_field,
						Label
						{
							id: "label";
							text: "City";
							layoutX: 220;
							layoutY: 250;
						}
						sm_vars.saleman_addCompany_city_field,
						Label
						{
							id: "label";
							text: "State";
							layoutX: 220;
							layoutY: 280;
						}
						sm_vars.saleman_addCompany_state_field,
						Label
						{
							id: "label";
							text: "Country";
							layoutX: 220;
							layoutY: 310;
						}
						sm_vars.saleman_addCompany_country_field,
						Button
						{
							text: "Add";
							layoutX: 375;
							layoutY: 350;
							transforms:
							[
								Scale {x: 1.2, y: 1.2}
							]
							action: function()
							{
								sm_vars.saleman_addCompany = true;
								if(sm_vars.saleman_addCompany_name_field.text == "")
								{
									sm_vars.saleman_addCompany_name_field.text = "* Company Name cannot be empty";
									sm_vars.saleman_addCompany = false;
								}
								else
								{
									var check_rs: ResultSet = admin_vars.st.executeQuery("select * from company_master where c_name = '{sm_vars.saleman_addCompany_name_field.text.toString()}'");
									if(check_rs.next())
									{
										sm_vars.saleman_addCompany = false;
										sm_vars.saleman_addCompany_name_field.text = "* Company already exists";
									}
								}
								if(sm_vars.saleman_addCompany_phno_field.text == "")
								{
									sm_vars.saleman_addCompany_phno_field.text = "* Phone No cannot be empty";
									sm_vars.saleman_addCompany = false;
								}
								if(sm_vars.saleman_addCompany_phno_field.text.length() < 10 or sm_vars.saleman_addCompany_phno_field.text.length() > 10)
								{
									sm_vars.saleman_addCompany_phno_field.text = "* Phone no must be 10 digits in length.";
									sm_vars.saleman_addCompany = false;
								}
								else
								{
									matcher = admin_vars.phonepattern.matcher(sm_vars.saleman_addCompany_phno_field.text);
									if(matcher.matches())
									{
									}
									else
									{
										sm_vars.saleman_addCompany_phno_field.text = "* Invalid Phone no.";
										sm_vars.saleman_addCompany = false;
									}
								}								
								if(sm_vars.saleman_addCompany_email_field.text == "")
								{
									sm_vars.saleman_addCompany_email_field.text = "* Email cannot be empty";
									sm_vars.saleman_addCompany = false;
								}
								else 
								{
									matcher = admin_vars.pattern.matcher(sm_vars.saleman_addCompany_email_field.text);
									if(matcher.matches())
									{
									}
									else
									{
										sm_vars.saleman_addCompany_email_field.text = "* Email is not valid";
										sm_vars.saleman_addCompany = false;
									}
								}
								if(sm_vars.saleman_addCompany_address_field.text == "")
								{
									sm_vars.saleman_addCompany_address_field.text = "* Address cannot be empty";
									sm_vars.saleman_addCompany = false;
								}
								if(sm_vars.saleman_addCompany_city_field.text == "")
								{
									sm_vars.saleman_addCompany_city_field.text = "* City cannot be empty";
									sm_vars.saleman_addCompany = false;
								}
								if(sm_vars.saleman_addCompany_state_field.text == "")
								{
									sm_vars.saleman_addCompany_state_field.text = "* State cannot be empty";
									sm_vars.saleman_addCompany = false;
								}
								if(sm_vars.saleman_addCompany_country_field.text == "")
								{
									sm_vars.saleman_addCompany_country_field.text = "* Country cannot be empty";
									sm_vars.saleman_addCompany = false;
								}
								admin_vars.rs1 = admin_vars.st.executeQuery("select * from COMPANY_MASTER where C_NAME='{sm_vars.saleman_addCompany_name_field.text}'");
								if(admin_vars.rs1.next())
								{
									sm_vars.saleman_addCompany_name_field.text = "* Company already exists.";
									sm_vars.saleman_addCompany = false;
								}
								if(sm_vars.saleman_addCompany == true)
								{									
									admin_vars.cs = admin_vars.cn.prepareCall("call ADD_COMPANY_MASTER(?,?,?,?,?,?,?)");
									admin_vars.cs.setString(1,'{sm_vars.saleman_addCompany_name_field.text}');
									admin_vars.cs.setString(2,'{sm_vars.saleman_addCompany_phno_field.text}');
									admin_vars.cs.setString(3,'{sm_vars.saleman_addCompany_email_field.text}');
									admin_vars.cs.setString(4,'{sm_vars.saleman_addCompany_address_field.text}');
									admin_vars.cs.setString(5,'{sm_vars.saleman_addCompany_city_field.text}');
									admin_vars.cs.setString(6,'{sm_vars.saleman_addCompany_state_field.text}');
									admin_vars.cs.setString(7,'{sm_vars.saleman_addCompany_country_field.text}');
									
									if(admin_vars.cs.executeUpdate() == 0)
									{
										insert sm_vars.saleman_addCompany_name_field.text into sm_vars.comp_nm;
										insert sm_vars.saleman_addCompany_phno_field.text into sm_vars.comp_phoneno;
										insert sm_vars.saleman_addCompany_email_field.text into sm_vars.comp_email;
										insert sm_vars.saleman_addCompany_city_field.text into sm_vars.comp_city;
										insert sm_vars.saleman_addCompany_state_field.text into sm_vars.comp_state;
										insert sm_vars.saleman_addCompany_country_field.text into sm_vars.comp_country;
										sm_vars.lv_comp_size = 55 * sm_vars.comp_nm.size();
										Alert.inform("The Company added successfully");
										insert sm_vars.saleman_addCompany_name_field.text into saleman_addClient_choicebox_item;
										addcompany_value_null();
									}
								}
							}
						}
					]
				}
		]
	visible:false;
}

// View Companies

admin_vars.rs1 = admin_vars.st.executeQuery("select * from COMPANY_MASTER");
while(admin_vars.rs1.next())
{
	insert admin_vars.rs1.getString(2).toString() into sm_vars.comp_nm;							
	insert admin_vars.rs1.getString(3).toString() into sm_vars.comp_phoneno;
	insert admin_vars.rs1.getString(4).toString() into sm_vars.comp_email;
	insert admin_vars.rs1.getString(6).toString() into sm_vars.comp_city;
	insert admin_vars.rs1.getString(7).toString() into sm_vars.comp_state;
	insert admin_vars.rs1.getString(8).toString() into sm_vars.comp_country;
}
sm_vars.lv_comp_size = 55 * sm_vars.comp_nm.size();

sm_vars.viewCompanyLabels = ListView
{
	layoutInfo: LayoutInfo{width: 570 height: 30}
	layoutX: 100
	layoutY: 100
	visible: bind not (sm_vars.viewCompanyListView.height == 0)
	cellFactory: function() {
        var listCell: ListCell = ListCell
		{
			node : HBox {
				content: [
                    VBox {
					layoutInfo: LayoutInfo{width: 100}
			        spacing: 10
                    content: [
                        Label {
                            text: "Name"
							font:Font.font("CALIBRI", FontWeight.BOLD, 20);
                            visible: bind not (sm_vars.viewCompanyListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 100}
			        spacing: 10
                    content: [
                        Label {
                            text: "Phone No."
							font:Font.font("CALIBRI", FontWeight.BOLD, 20);
                            visible: bind not (sm_vars.viewCompanyListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 160}
			        spacing: 10
                    content: [
                        Label {
                            text: "Email"
							font:Font.font("CALIBRI", FontWeight.BOLD, 20);
                            visible: bind not (sm_vars.viewCompanyListView.height == 0)
						}
                    ]
					}					
					VBox {
					layoutInfo: LayoutInfo{width: 100}
			        spacing: 10
                    content: [
						Label {
                            text: "Edit"
							font:Font.font("CALIBRI", FontWeight.BOLD, 20);
                            visible: bind not (sm_vars.viewCompanyListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 100}
			        spacing: 10
                    content: [          
						Label {
                            text: "Delete"
							font:Font.font("CALIBRI", FontWeight.BOLD, 20);
                            visible: bind not (sm_vars.viewCompanyListView.height == 0)
						}
                    ]
					}
				]
			}
		}
	}
}
sm_vars.viewCompanyListView = ListView {
        items: bind [sm_vars.comp_nm]
		layoutInfo: LayoutInfo{height:bind sm_vars.lv_comp_size width: 570}
		layoutX: 100
		layoutY: 150
		
        cellFactory: function() {
            var listCell: ListCell;           
			
			if(sm_vars.comp_nm.size() > 5)
            {
                sm_vars.lv_comp_size = 55 * 5;
            }
            else
            {
                sm_vars.lv_comp_size = 55 * sm_vars.comp_nm.size();
            }
            listCell = ListCell {
                node : HBox {
					content: [
                         VBox {
							layoutInfo: LayoutInfo{width: 100}
			                spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.comp_nm[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_comp_flag or not listCell.selected or (sm_vars.lv_comp_ind != listCell.index)
                                }
                                sm_vars.lv_comp_nm_t = TextBox
                                {
									id: "lbl"
                                    promptText: bind sm_vars.comp_nm[listCell.index]
                                    onKeyPressed: function(ke: KeyEvent)
                                    {
                                        if(ke.code.toString() == "VK_BACK_SPACE")
                                        {
                                            sm_vars.lv_comp_len = sm_vars.lv_comp_nm.length();
                                            sm_vars.lv_comp_nm = removeLastChar(sm_vars.lv_comp_nm);
                                        }
                                    }
                                    onKeyTyped: function(e:KeyEvent)
                                    {
                                        if(sm_vars.lv_comp_len != 0)
                                        {
                                            sm_vars.lv_comp_len = 0;
                                        }
                                        else if(sm_vars.lv_comp_nm == "")
                                        {
                                            sm_vars.lv_comp_nm = e.char;
                                        }
                                        else
                                        {
                                            sm_vars.lv_comp_nm = '{sm_vars.lv_comp_nm}{e.char}';
                                        }
                                    }
									focusTraversable: true
                                    columns: 12
                                    visible:bind not listCell.empty and sm_vars.lv_comp_flag and listCell.selected and (sm_vars.lv_comp_ind == listCell.index)
                                }
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
			                spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.comp_phoneno[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_comp_flag or not listCell.selected or (sm_vars.lv_comp_ind != listCell.index)
                                }
                                sm_vars.lv_comp_phoneno_t = TextBox
                                {
									id: "lbl"
                                    promptText: bind sm_vars.comp_phoneno[listCell.index]
                                    onKeyPressed: function(ke: KeyEvent)
                                    {
                                        if(ke.code.toString() == "VK_BACK_SPACE")
                                        {
                                            sm_vars.lv_comp_len = sm_vars.lv_comp_nm.length();
                                            sm_vars.lv_comp_phoneno = removeLastChar(sm_vars.lv_comp_phoneno);
                                        }
                                    }
                                    onKeyTyped: function(e:KeyEvent)
                                    {
                                        if(sm_vars.lv_comp_len != 0)
                                        {
                                            sm_vars.lv_comp_len = 0;
                                        }
                                        else if(sm_vars.lv_comp_nm == "")
                                        {
                                            sm_vars.lv_comp_phoneno = e.char;
                                        }
                                        else
                                        {
                                            sm_vars.lv_comp_phoneno = '{sm_vars.lv_comp_phoneno}{e.char}';
                                        }
                                    }
									focusTraversable: true
                                    columns: 12
                                    visible:bind not listCell.empty and sm_vars.lv_comp_flag and listCell.selected and (sm_vars.lv_comp_ind == listCell.index)
                                }
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 160}
			                spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.comp_email[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_comp_flag or not listCell.selected or (sm_vars.lv_comp_ind != listCell.index)
                                }
                                sm_vars.lv_comp_email_t = TextBox
                                {
									id: "lbl"
                                    promptText: bind sm_vars.comp_email[listCell.index]
                                    onKeyPressed: function(ke: KeyEvent)
                                    {
                                        if(ke.code.toString() == "VK_BACK_SPACE")
                                        {
                                            sm_vars.lv_comp_len = sm_vars.lv_comp_email.length();
                                            sm_vars.lv_comp_email = removeLastChar(sm_vars.lv_comp_email);
                                        }
                                    }
                                    onKeyTyped: function(e:KeyEvent)
                                    {
                                        if(sm_vars.lv_comp_len != 0)
                                        {
                                            sm_vars.lv_comp_len = 0;
                                        }
                                        else if(sm_vars.lv_comp_email == "")
                                        {
                                            sm_vars.lv_comp_email = e.char;
                                        }
                                        else
                                        {
                                            sm_vars.lv_comp_email = '{sm_vars.lv_comp_email}{e.char}';
                                        }
                                    }
									focusTraversable: true
                                    columns: 12
                                    visible:bind not listCell.empty and sm_vars.lv_comp_flag and listCell.selected and (sm_vars.lv_comp_ind == listCell.index)
                                }
                            ]
                        }
                        VBox{
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Button {
                                    vpos: VPos.TOP;
                                    text: "Edit"
                                    visible: bind not listCell.empty and (not sm_vars.lv_comp_flag or not listCell.selected or (sm_vars.lv_comp_ind != listCell.index))
                                    action: function() {
                                        sm_vars.lv_comp_ind = listCell.index;
                                        sm_vars.lv_comp_flag = true;
                                    }
                                }
                                sm_vars.lv_comp_upBtn = Button {
                                    vpos: VPos.TOP;
                                    text: "Update"
                                    visible: bind not listCell.empty and sm_vars.lv_comp_flag and listCell.selected and (sm_vars.lv_comp_ind == listCell.index)
                                    action: function() {
										admin_vars.rs1 = admin_vars.st.executeQuery("select * from company_master where c_name='{sm_vars.lv_comp_nm}'");
										if(admin_vars.rs1.next() and sm_vars.lv_comp_nm != sm_vars.comp_nm[listCell.index])
										{
											Alert.inform("Company Name already exists.");
										}										
										else if(sm_vars.lv_comp_nm != "" or sm_vars.lv_comp_phoneno != "" or sm_vars.lv_comp_email != "")
										{	
											sm_vars.lv_comp_nm = sm_vars.lv_comp_nm.trim();
											sm_vars.lv_comp_phoneno = sm_vars.lv_comp_phoneno.trim();
											sm_vars.lv_comp_email = sm_vars.lv_comp_email.trim();
											matcher = admin_vars.phonepattern.matcher(sm_vars.lv_comp_phoneno);
											var matcher2: Matcher;
											matcher2 = admin_vars.pattern.matcher(sm_vars.lv_comp_email);											
											if(sm_vars.lv_comp_phoneno.length() > 10 or not matcher.matches() or sm_vars.lv_comp_phoneno.length() < 10)
											{
												Alert.inform("Invalid Phone No.");
											}
											else if(sm_vars.lv_comp_nm.length() > 200)
											{
												Alert.inform("Too Large value for Company Name");
											}											
											else if(not matcher2.matches() or sm_vars.lv_comp_email.length() > 50)
											{
												Alert.inform("Invalid Email.");
											}
											else
											{												
												admin_vars.cs = admin_vars.cn.prepareCall("call update_company(?,?,?,?)");
												admin_vars.cs.setString(1,'{sm_vars.comp_nm[listCell.index]}');
												admin_vars.cs.setString(2,'{sm_vars.lv_comp_nm}');
												admin_vars.cs.setString(3,'{sm_vars.lv_comp_phoneno}');
												admin_vars.cs.setString(4,'{sm_vars.lv_comp_email}');
												
												if(admin_vars.cs.executeUpdate() == 0)
												{
													Alert.inform("Your data updated successfully.");
													sm_vars.lv_comp_flag = false;
													sm_vars.comp_nm[listCell.index] = {sm_vars.lv_comp_nm};
													sm_vars.comp_phoneno[listCell.index] = {sm_vars.lv_comp_phoneno};
													sm_vars.comp_email[listCell.index] = {sm_vars.lv_comp_email};
													sm_vars.lv_comp_nm = "";
													sm_vars.lv_comp_phoneno = "";
													sm_vars.lv_comp_email = "";
												}
											}
										}
										else
										{
											Alert.inform("Enter values to update.");
										}
                                    }
                                }
                            ]
                        }
                        VBox{
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Button {
                                    vpos: VPos.TOP;
                                    text: "Delete"
                                    visible: bind not listCell.empty and (not sm_vars.lv_comp_flag or not listCell.selected or (sm_vars.lv_comp_ind != listCell.index))
                                    action: function() {
                                        admin_vars.cs = admin_vars.cn.prepareCall("call delete_company(?)");
                                        admin_vars.cs.setString(1,'{sm_vars.comp_nm[listCell.index]}');
                                        admin_vars.cs.executeUpdate();
                                        delete sm_vars.comp_nm[listCell.index] from sm_vars.comp_nm;
                                        delete sm_vars.comp_phoneno[listCell.index] from sm_vars.comp_phoneno;
										delete sm_vars.comp_email[listCell.index] from sm_vars.comp_email;
										sm_vars.comp_city[listCell.index] = "";
										delete ""  from sm_vars.comp_city;
										sm_vars.comp_state[listCell.index] = "";
										delete "" from sm_vars.comp_state;
										sm_vars.comp_country[listCell.index] = "";
										delete ""  from sm_vars.comp_country;
										sm_vars.lv_comp_size = 55 * sm_vars.comp_nm.size();
                                    }
                                }
                            ]
                        }
                    ]
                }					
            }
        }
        visible:true;
    };
	
sm_vars.salesmanager_view_company = Panel
{
	content : 
	[
		Panel
		{
			layoutX: 200,
			layoutY: 100,
			height: 550,
			width: 800
			content:
			[
				Label
                {
                    text: "Companies";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
				{
					text: "You have not added any companies yet.";
                    layoutX: 220;
                    layoutY: 150;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (sm_vars.viewCompanyListView.height == 0)
				}
				sm_vars.viewCompanyLabels,
				sm_vars.viewCompanyListView,
			]
		}
	]
	visible: false;
}


// Add Client

sm_vars.saleman_addClient_firstname_field = TextBox
{
	columns: 20;
	layoutX: 360;
	layoutY: 100;
	multiline: true;
	lines: 1;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addClient_firstname_field.columns = 30;
		sm_vars.saleman_addClient_firstname_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addClient_firstname_field.columns = 20;
		sm_vars.saleman_addClient_firstname_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.saleman_addClient == false)
		{
			sm_vars.saleman_addClient_firstname_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addClient_middlename_field.requestFocus();
			sm_vars.saleman_addClient_firstname_field.text = sm_vars.saleman_addClient_firstname_field.text.trim();
		}
	}
}
sm_vars.saleman_addClient_middlename_field = TextBox
{
	columns: 20;
	layoutX: 360;
	layoutY: 130;
	multiline: true;
	lines: 1;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addClient_middlename_field.columns = 30;
		sm_vars.saleman_addClient_middlename_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addClient_middlename_field.columns = 20;
		sm_vars.saleman_addClient_middlename_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.saleman_addClient == false)
		{
			sm_vars.saleman_addClient_middlename_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addClient_lastname_field.requestFocus();
			sm_vars.saleman_addClient_middlename_field.text = sm_vars.saleman_addClient_middlename_field.text.trim();
		}
	}
}
sm_vars.saleman_addClient_lastname_field = TextBox
{
	columns: 20;
	layoutX: 360;
	layoutY: 160;
	multiline: true;
	lines: 1;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addClient_lastname_field.columns = 30;
		sm_vars.saleman_addClient_lastname_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addClient_lastname_field.columns = 20;
		sm_vars.saleman_addClient_lastname_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.saleman_addClient == false)
		{
			sm_vars.saleman_addClient_lastname_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			saleman_addClient_choicebox.requestFocus();
			sm_vars.saleman_addClient_lastname_field.text = sm_vars.saleman_addClient_lastname_field.text.trim();
		}
	}
}
var saleman_addClient_choicebox_item: String[];
var saleman_addClient_choicebox = ChoiceBox
{
	id: "cb";
	layoutX: 388;
	layoutY: 190;
	scaleX: 1.5;                                        
	items: bind [saleman_addClient_choicebox_item];
	layoutInfo: LayoutInfo { width: 100 };
	
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addClient_phoneno_field.requestFocus();
		}
	}
}
sm_vars.saleman_addClient_phoneno_field = TextBox
{
	columns: 20;
	layoutX: 360;
	layoutY: 220;
	multiline: true;
	lines: 1;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addClient_phoneno_field.columns = 30;
		sm_vars.saleman_addClient_phoneno_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addClient_phoneno_field.columns = 20;
		sm_vars.saleman_addClient_phoneno_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.saleman_addClient == false)
		{
			sm_vars.saleman_addClient_phoneno_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addClient_email_field.requestFocus();
			sm_vars.saleman_addClient_phoneno_field.text = sm_vars.saleman_addClient_phoneno_field.text.trim();
		}
	}
}
sm_vars.saleman_addClient_email_field = TextBox
{
	columns: 20;
	layoutX: 360;
	layoutY: 250;
	multiline: true;
	lines: 1;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addClient_email_field.columns = 30;
		sm_vars.saleman_addClient_email_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addClient_email_field.columns = 20;
		sm_vars.saleman_addClient_email_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.saleman_addClient == false)
		{
			sm_vars.saleman_addClient_email_field.text = "";
		}
	}
}

var saleman_add_client : Panel = Panel
{
    content :
        [
            Panel
                {
					layoutX: 200,
					layoutY: 100,
					height: 550,
					width: 800
                    content:
                    [
						Label
						{
							text: "Add Client";
							layoutX: 300;
							layoutY: 40;
							font:Font.font("ARIAL", FontWeight.BOLD, 20);
							effect:Glow {level:0.5};
						}
						Label
						{
							id: "label";
							text: "First Name";
							layoutX: 230;
							layoutY: 100;
						}
						sm_vars.saleman_addClient_firstname_field,
						Label
						{
							id: "label";
							text: "Middle Name";
							layoutX: 230;
							layoutY: 130;
						}
						sm_vars.saleman_addClient_middlename_field,
						Label
						{
							id: "label";
							text: "Last Name";
							layoutX: 230;
							layoutY: 160;
						}
						sm_vars.saleman_addClient_lastname_field,
						Label
						{
							id: "label";
							text: "Company Detail";
							layoutX: 230;
							layoutY: 190;
						}
						saleman_addClient_choicebox,
						Label
						{
							id: "label";
							text: "Phone No";
							layoutX: 230;
							layoutY: 220;
						}
						sm_vars.saleman_addClient_phoneno_field,
						Label
						{
							id: "label";
							text: "E-Mail";
							layoutX: 230;
							layoutY: 250;
						}
						sm_vars.saleman_addClient_email_field,
						Button
						{
							text: "Add";
							layoutX: 360;
							layoutY: 280;
							transforms:
							[
								Scale {x: 1.2, y: 1.2}
							]
							action: function()
							{
								sm_vars.saleman_addClient = true;
								if(sm_vars.saleman_addClient_firstname_field.text == "")
								{
									sm_vars.saleman_addClient_firstname_field.text = "* First Name cannot be empty";
									sm_vars.saleman_addClient = false;
								}
								if(sm_vars.saleman_addClient_middlename_field.text == "")
								{
									sm_vars.saleman_addClient_middlename_field.text = "* Middle Name cannot be empty";
									sm_vars.saleman_addClient = false;
								}
								if(sm_vars.saleman_addClient_lastname_field.text == "")
								{
									sm_vars.saleman_addClient_lastname_field.text = "* Last Name cannot be empty";
									sm_vars.saleman_addClient = false;
								}
								if(saleman_addClient_choicebox.selectedIndex == -1)
								{
									Alert.inform("select Company.");
									sm_vars.saleman_addClient = false;
								}
								if(sm_vars.saleman_addClient_phoneno_field.text == "")
								{
									sm_vars.saleman_addClient_phoneno_field.text = "* Phone no cannot be empty";
									sm_vars.saleman_addClient = false;
								}
								if(sm_vars.saleman_addClient_phoneno_field.text.length() < 10 or sm_vars.saleman_addClient_phoneno_field.text.length() > 10)
								{
									sm_vars.saleman_addClient_phoneno_field.text = "* Phone no must be 10 digits in length.";
									sm_vars.saleman_addClient = false;
								}
								else
								{
									matcher = admin_vars.phonepattern.matcher(sm_vars.saleman_addClient_phoneno_field.text);
									if(matcher.matches())
									{
									}
									else
									{
										sm_vars.saleman_addClient_phoneno_field.text = "* Invalid Phone no.";
										sm_vars.saleman_addClient = false;
									}
								}
								if(sm_vars.saleman_addClient_email_field.text == "")
								{
									sm_vars.saleman_addClient_email_field.text = "* Email cannot be empty";
									sm_vars.saleman_addClient = false;
								}
								if(sm_vars.saleman_addClient_email_field.text != "")
								{
									matcher = admin_vars.pattern.matcher(sm_vars.saleman_addClient_email_field.text);
									if(matcher.matches())
									{
										var check_rs: ResultSet = admin_vars.st.executeQuery("select * from client_master where cl_email_id = '{sm_vars.saleman_addClient_email_field.text.toString()}'");
										if(check_rs.next())
										{
											sm_vars.saleman_addClient_email_field.text = "* Email already exists";
											sm_vars.saleman_addClient = false;
										}
									}
									else
									{
										sm_vars.saleman_addClient_email_field.text = "* Email is not valid";
										sm_vars.saleman_addClient = false;
									}
								}
								
								if(sm_vars.saleman_addClient == true)
								{
									admin_vars.cs1 = admin_vars.cn.prepareCall("call GET_COMPANY_ID(?,?)");
									admin_vars.cs1.setString(1,'{saleman_addClient_choicebox.selectedItem}');
									admin_vars.cs1.registerOutParameter(2,Types.INTEGER);
									admin_vars.cs1.executeUpdate();
									
									admin_vars.cs = admin_vars.cn.prepareCall("call ADD_CLIENT_MASTER(?,?,?,?,?,?,?)");
									admin_vars.cs.setString(1,'{sm_vars.saleman_addClient_firstname_field.text}');
									admin_vars.cs.setString(2,'{sm_vars.saleman_addClient_middlename_field.text}');
									admin_vars.cs.setString(3,'{sm_vars.saleman_addClient_lastname_field.text}');
									admin_vars.cs.setInt(4,admin_vars.cs1.getInt(2));
									admin_vars.cs.setString(5,'{saleman_addClient_choicebox.selectedItem}');
									admin_vars.cs.setString(6,'{sm_vars.saleman_addClient_phoneno_field.text}');
									admin_vars.cs.setString(7,'{sm_vars.saleman_addClient_email_field.text}');
									
									if(admin_vars.cs.executeUpdate() == 0)
									{
										Alert.inform("The Client added successfully");
										insert "{sm_vars.saleman_addClient_firstname_field.text} {sm_vars.saleman_addClient_lastname_field.text}" into sm_vars.cl_nm;
										insert '{saleman_addClient_choicebox.selectedItem}' into sm_vars.cl_compnm;
										insert {sm_vars.saleman_addClient_phoneno_field.text} into sm_vars.cl_phoneno;
										insert {sm_vars.saleman_addClient_email_field.text} into sm_vars.cl_email;
										if(sm_vars.cl_email.size() <= 5)
										{
											sm_vars.lv_cl_size = 55 * sm_vars.cl_email.size();
										}
										else 
										{
											sm_vars.lv_cl_size = 55 * 5;
										}
										addclient_value_null();
									}
								}
							}
						}
					]
				}
		]
	visible:false;
}

// View Clients

admin_vars.rs1 = admin_vars.st.executeQuery("select * from CLIENT_MASTER");
while(admin_vars.rs1.next())
{
	insert "{admin_vars.rs1.getString(2).toString()} {admin_vars.rs1.getString(4).toString()}" into sm_vars.cl_nm;	
	insert admin_vars.rs1.getString(6).toString() into sm_vars.cl_compnm;
	insert admin_vars.rs1.getString(7).toString() into sm_vars.cl_phoneno;
	insert admin_vars.rs1.getString(8).toString() into sm_vars.cl_email;
}
sm_vars.lv_cl_size = 55 * sm_vars.cl_email.size();

sm_vars.viewClientLabels = ListView
{
	layoutInfo: LayoutInfo{width: 720 height: 30}
	layoutX: 35
	layoutY: 100
	visible: bind not (sm_vars.viewClientListView.height == 0)
	cellFactory: function() {
        var listCell: ListCell = ListCell
		{
			node : HBox {
				content: [
                    VBox {
					layoutInfo: LayoutInfo{width: 150}
			        spacing: 10
                    content: [
                        Label {
                            text: "Name"
							font:Font.font("CALIBRI", FontWeight.BOLD, 20);
                            visible: bind not (sm_vars.viewClientListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 100}
			        spacing: 10
                    content: [
                        Label {
                            text: "Company Name"
							font:Font.font("CALIBRI", FontWeight.BOLD, 20);
                            visible: bind not (sm_vars.viewClientListView.height == 0)
						}
                    ]
					}					
					VBox {
					layoutInfo: LayoutInfo{width: 100}
			        spacing: 10
                    content: [
                        Label {
                            text: "Phone No"
							font:Font.font("CALIBRI", FontWeight.BOLD, 20);
                            visible: bind not (sm_vars.viewClientListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 160}
			        spacing: 10
                    content: [
                        Label {
                            text: "Email"
							font:Font.font("CALIBRI", FontWeight.BOLD, 20);
                            visible: bind not (sm_vars.viewClientListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 100}
			        spacing: 10
                    content: [
						Label {
                            text: "Edit"
							font:Font.font("CALIBRI", FontWeight.BOLD, 20);
                            visible: bind not (sm_vars.viewCompanyListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 100}
			        spacing: 10
                    content: [          
						Label {
                            text: "Delete"
							font:Font.font("CALIBRI", FontWeight.BOLD, 20);
                            visible: bind not (sm_vars.viewCompanyListView.height == 0)
						}
                    ]
					}
				]
			}
		}
	}
}
sm_vars.viewClientListView = ListView {
        items: bind [sm_vars.cl_email]
		layoutInfo: LayoutInfo{height:bind sm_vars.lv_cl_size width: 720}
		layoutX: 35
		layoutY: 150
		
        cellFactory: function() {
            var listCell: ListCell;           
			
			if(sm_vars.cl_email.size() > 5)
            {
                sm_vars.lv_cl_size = 55 * 5;
            }
            else
            {
                sm_vars.lv_cl_size = 55 * sm_vars.cl_email.size();
            }
            listCell = ListCell {
                node : HBox {
					content: [
                         VBox {
							layoutInfo: LayoutInfo{width: 150}
			                spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.cl_nm[listCell.index]
                                    visible: bind not listCell.empty
                                }
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
			                spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.cl_compnm[listCell.index]
                                    visible: bind not listCell.empty
                                }
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
			                spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.cl_phoneno[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_cl_flag or not listCell.selected or (sm_vars.lv_cl_ind != listCell.index)
                                }
                                sm_vars.lv_cl_phoneno_t = TextBox
                                {
									id: "lbl"
                                    promptText: bind sm_vars.cl_phoneno[listCell.index]
                                    onKeyPressed: function(ke: KeyEvent)
                                    {
                                        if(ke.code.toString() == "VK_BACK_SPACE")
                                        {
                                            sm_vars.lv_cl_len = sm_vars.lv_cl_phoneno.length();
                                            sm_vars.lv_cl_phoneno = removeLastChar(sm_vars.lv_cl_phoneno);
                                        }
                                    }
                                    onKeyTyped: function(e:KeyEvent)
                                    {
                                        if(sm_vars.lv_cl_len != 0)
                                        {
                                            sm_vars.lv_cl_len = 0;
                                        }
                                        else if(sm_vars.lv_cl_phoneno == "")
                                        {
                                            sm_vars.lv_cl_phoneno = e.char;
                                        }
                                        else
                                        {
                                            sm_vars.lv_cl_phoneno = '{sm_vars.lv_cl_phoneno}{e.char}';
                                        }
                                    }
									focusTraversable: true
                                    columns: 12
                                    visible:bind not listCell.empty and sm_vars.lv_cl_flag and listCell.selected and (sm_vars.lv_cl_ind == listCell.index)
                                }
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 160}
			                spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.cl_email[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_cl_flag or not listCell.selected or (sm_vars.lv_cl_ind != listCell.index)
                                }
                                sm_vars.lv_cl_email_t = TextBox
                                {
									id: "lbl"
                                    promptText: bind sm_vars.cl_email[listCell.index]
                                    onKeyPressed: function(ke: KeyEvent)
                                    {
                                        if(ke.code.toString() == "VK_BACK_SPACE")
                                        {
                                            sm_vars.lv_cl_len = sm_vars.lv_cl_email.length();
                                            sm_vars.lv_cl_email = removeLastChar(sm_vars.lv_cl_email);
                                        }
                                    }
                                    onKeyTyped: function(e:KeyEvent)
                                    {
                                        if(sm_vars.lv_cl_len != 0)
                                        {
                                            sm_vars.lv_cl_len = 0;
                                        }
                                        else if(sm_vars.lv_cl_email == "")
                                        {
                                            sm_vars.lv_cl_email = e.char;
                                        }
                                        else
                                        {
                                            sm_vars.lv_cl_email = '{sm_vars.lv_cl_email}{e.char}';
                                        }
                                    }
									focusTraversable: true
                                    columns: 12
                                    visible:bind not listCell.empty and sm_vars.lv_cl_flag and listCell.selected and (sm_vars.lv_cl_ind == listCell.index)
                                }
                            ]
                        }
                        VBox{
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Button {
                                    vpos: VPos.TOP;
                                    text: "Edit"
                                    visible: bind not listCell.empty and (not sm_vars.lv_cl_flag or not listCell.selected or (sm_vars.lv_cl_ind != listCell.index))
                                    action: function() {
                                        sm_vars.lv_cl_ind = listCell.index;
                                        sm_vars.lv_cl_flag = true;
                                    }
                                }
                                sm_vars.lv_cl_upBtn = Button {
                                    vpos: VPos.TOP;
                                    text: "Update"
                                    visible: bind not listCell.empty and sm_vars.lv_cl_flag and listCell.selected and (sm_vars.lv_cl_ind == listCell.index)
                                    action: function() {
										if(sm_vars.lv_cl_email != "" and sm_vars.lv_cl_phoneno != "")
										{
											sm_vars.lv_cl_email = sm_vars.lv_cl_email.trim();
											sm_vars.lv_cl_phoneno = sm_vars.lv_cl_phoneno.trim();
											matcher = admin_vars.phonepattern.matcher(sm_vars.lv_cl_phoneno);
											var matcher2 : Matcher;
											matcher2 = admin_vars.pattern.matcher(sm_vars.lv_cl_email);
											if(not matcher.matches() or sm_vars.lv_cl_phoneno.length() > 10 or sm_vars.lv_cl_phoneno.length() < 10)
											{
												Alert.inform("Invalid Phone Number.");
											}
											else if(not matcher2.matches() or sm_vars.lv_cl_email.length() > 50)
											{
												Alert.inform("Invalid Email.");
											}
											else
											{
												admin_vars.cs = admin_vars.cn.prepareCall("call update_client(?,?,?)");
												admin_vars.cs.setString(1,{sm_vars.cl_email[listCell.index]});
												admin_vars.cs.setString(2,{sm_vars.lv_cl_email});
												admin_vars.cs.setString(3,{sm_vars.lv_cl_phoneno});
												if(admin_vars.cs.executeUpdate() == 0)
												{
													Alert.inform("Client data updated successfully.");
													sm_vars.cl_email[listCell.index] = sm_vars.lv_cl_email;
													sm_vars.cl_phoneno[listCell.index] = sm_vars.lv_cl_phoneno;
													sm_vars.lv_cl_flag = false;
													sm_vars.lv_cl_email = "";
													sm_vars.lv_cl_phoneno = "";
												}
											}
										}
										else
										{
											Alert.inform("Enter values to update.");
										}
                                    }
                                }
                            ]
                        }
                        VBox{
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Button {
                                    vpos: VPos.TOP;
                                    text: "Delete"
                                    visible: bind not listCell.empty and (not sm_vars.lv_cl_flag or not listCell.selected or (sm_vars.lv_cl_ind != listCell.index))
                                    action: function() {
                                        admin_vars.cs = admin_vars.cn.prepareCall("call delete_client(?)");
                                        admin_vars.cs.setString(1,'{sm_vars.cl_email[listCell.index]}');
                                        admin_vars.cs.executeUpdate();
                                        delete sm_vars.cl_email[listCell.index] from sm_vars.cl_email;
                                        delete sm_vars.cl_nm[listCell.index] from sm_vars.cl_nm;
										delete sm_vars.cl_compnm[listCell.index] from sm_vars.cl_compnm;
										delete sm_vars.cl_phoneno[listCell.index] from sm_vars.cl_phoneno;
										if(sm_vars.cl_email.size() <= 5)
										{
											sm_vars.lv_cl_size = 55 * sm_vars.cl_email.size();
										}
										else 
										{
											sm_vars.lv_cl_size = 55 * 5;
										}
                                    }
                                }
                            ]
                        }
                    ]
                }					
            }
        }
        visible:true;
    };
	
sm_vars.salesmanager_view_client = Panel
{
	content : 
	[
		Panel
		{
			layoutX: 200,
			layoutY: 100,
			height: 550,
			width: 800
			content:
			[
				Label
                {
                    text: "Clients";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
				{
					text: "You have not added any clients yet.";
                    layoutX: 220;
                    layoutY: 150;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (sm_vars.viewClientListView.height == 0)
				}
				sm_vars.viewClientLabels,
				sm_vars.viewClientListView,
			]
		}
	]
	visible: false;
}

// Add stock

sm_vars.add_stock_product = ChoiceBox
{
	id: "cb";
	layoutX: 373;
	layoutY: 100;
	scaleX: 1.3; 
	layoutInfo: LayoutInfo { width: 95 }
	items: bind [sm_vars.add_stock_item];
}

sm_vars.add_stock_qty = TextBox
{
	columns: 16;
	layoutX: 360;
	layoutY: 130;
	multiline: true;
	lines: 1;
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.add_stock == false)
		{
			sm_vars.add_stock_qty.text = "";
		}
	}
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.add_stock_qty.columns = 25;
		sm_vars.add_stock_qty.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.add_stock_qty.columns = 16;
		sm_vars.add_stock_qty.translateX = 1;
    }
}

sm_vars.salesmanager_add_stock = Panel
{
    content :
    [
        Panel
        {
			layoutX: 200,
			layoutY: 100,
			height: 550,
			width: 800
            content:
                [
                    Label
                    {
                        text: "Add stock";
                        layoutX: 300;
                        layoutY: 40;
                        font:Font.font("ARIAL", FontWeight.BOLD, 20);
                        effect:Glow {level:0.5};
                    }
					
                    
					Label
                    {
						id: "label";
                        text: "Product";
                        layoutX: 270;
                        layoutY: 100;                        
                    }
					sm_vars.add_stock_product,
                    Label
                    {
						id: "label";
                        text: "Quantity";
                        layoutX: 270;
                        layoutY: 130;                        
                    }
                    sm_vars.add_stock_qty,
					
                    Button
                    {
                        text: "Add Stock";
                        layoutX: 360;
						layoutY: 160;
                        transforms:
                        [
                            Scale {x: 1.2, y: 1.2}
                        ]
                        action: function()
                        {
							sm_vars.add_stock = true;
							if(sm_vars.add_stock_product.selectedIndex == -1)
							{
								Alert.inform("Select product.");
								sm_vars.add_stock = false;
							}
							if(sm_vars.add_stock_qty.text == "")
							{
								sm_vars.add_stock_qty.text = "* Enter quantity.";
								sm_vars.add_stock = false;
							}
							else
							{
								admin_vars.matcher = sm_vars.stockpattern.matcher(sm_vars.add_stock_qty.text);
								if(admin_vars.matcher.matches())
								{
									
								}
								else
								{
									sm_vars.add_stock_qty.text = "* Qty should be in digits.";
									sm_vars.add_stock = false;
								}
							}
													
							if(sm_vars.add_stock == true)
							{	
									admin_vars.rs = admin_vars.st.executeQuery("select QUANTITY from PRODUCT_MASTER where NAME='{sm_vars.add_stock_product.selectedItem}'");
									if(admin_vars.rs.next())
									{
										admin_vars.st.executeUpdate("update PRODUCT_MASTER set QUANTITY = {admin_vars.rs.getInt(1) + Integer.parseInt({sm_vars.add_stock_qty.text})} where NAME='{sm_vars.add_stock_product.selectedItem.toString()}'");
									}
									Alert.inform("Stock inserted successfully.");
									add_stock_null();	
							}
                        }
                    }					
                ]
        }
    ]
visible:false;
}

//view stock

sm_vars.viewStockListView = ListView {
        items: bind [sm_vars.stock_name]
		layoutInfo: LayoutInfo{height:bind sm_vars.lv_stock_size width: 270}
		layoutX: 240
		layoutY: 150
		
        cellFactory: function() {
            var listCell: ListCell;           
			
			if(sm_vars.stock_name.size() > 5)
            {
                sm_vars.lv_stock_size = 30 * 5;
            }
            else
            {
                sm_vars.lv_stock_size = 30 * sm_vars.stock_name.size();
            }
            listCell = ListCell {
                node : HBox {
					content: [
                         VBox {
							layoutInfo: LayoutInfo{width: 150}
			                spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.stock_name[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_stock_flag or not listCell.selected or (sm_vars.lv_stock_ind != listCell.index)
                                }                                
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.stock_qty[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_stock_flag or not listCell.selected or (sm_vars.lv_stock_ind != listCell.index)
                                }                  
                            ]
                        }
                        ]
                        }            
            }
        }
        visible:true;
    };
	
sm_vars.salesmanager_view_stock = Panel
{
	content : 
	[
		Panel
		{
			layoutX: 200,
			layoutY: 100,
			height: 550,
			width: 800
			content:
			[
				Label
                {
                    text: "Product Stocks";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
				{
					text: "You have not added any stocks yet.";
                    layoutX: 220;
                    layoutY: 150;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (sm_vars.viewStockListView.height == 0)
				}
				ListView
				{
					layoutInfo: LayoutInfo{width: 270 height: 30}
					layoutX: 240
					layoutY: 100
					visible: bind not (sm_vars.viewStockListView.height == 0)
					cellFactory: function() {
						var listCell: ListCell = ListCell
						{
							node : HBox {
								content: [
									VBox {
									layoutInfo: LayoutInfo{width: 150}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Product Name"
											visible: bind not (sm_vars.viewStockListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Quantity"
											visible: bind not (sm_vars.viewStockListView.height == 0)
										}
									]
									}					
								]
							}
						}
					}
				}
				sm_vars.viewStockListView,
			]
		}
	]
	visible: false;
}

// Add Person

sm_vars.saleman_addsalesperson_fnm_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 350;
	layoutY: 100;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_fnm_field.columns = 30;
		sm_vars.saleman_addsalesperson_fnm_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_fnm_field.columns = 20;
		sm_vars.saleman_addsalesperson_fnm_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.add_sales_person == false)
		{
			sm_vars.saleman_addsalesperson_fnm_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addsalesperson_mnm_field.requestFocus();
			sm_vars.saleman_addsalesperson_fnm_field.text = sm_vars.saleman_addsalesperson_fnm_field.text.trim();
		}
	}
}
sm_vars.saleman_addsalesperson_mnm_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 350;
	layoutY: 130;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_mnm_field.columns = 30;
		sm_vars.saleman_addsalesperson_mnm_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_mnm_field.columns = 20;
		sm_vars.saleman_addsalesperson_mnm_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.add_sales_person == false)
		{
			sm_vars.saleman_addsalesperson_mnm_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addsalesperson_lnm_field.requestFocus();
			sm_vars.saleman_addsalesperson_mnm_field.text = sm_vars.saleman_addsalesperson_mnm_field.text.trim();
		}
	}
}
sm_vars.saleman_addsalesperson_lnm_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 350;
	layoutY: 160;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_lnm_field.columns = 30;
		sm_vars.saleman_addsalesperson_lnm_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_lnm_field.columns = 20;
		sm_vars.saleman_addsalesperson_lnm_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.add_sales_person == false)
		{
			sm_vars.saleman_addsalesperson_lnm_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addsalesperson_unm_field.requestFocus();
			sm_vars.saleman_addsalesperson_lnm_field.text = sm_vars.saleman_addsalesperson_lnm_field.text.trim();
		}
	}
}
sm_vars.saleman_addsalesperson_unm_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 350;
	layoutY: 190;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_unm_field.columns = 30;
		sm_vars.saleman_addsalesperson_unm_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_unm_field.columns = 20;
		sm_vars.saleman_addsalesperson_unm_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.add_sales_person == false)
		{
			sm_vars.saleman_addsalesperson_unm_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			saleman_addsalesperson_pass_field.requestFocus();
			sm_vars.saleman_addsalesperson_unm_field.text = sm_vars.saleman_addsalesperson_unm_field.text.trim();
		}
	}
}
var saleman_addsalesperson_pass_field = PasswordBox
{
	columns: 20;
	layoutX: 350;
	layoutY: 220;
	transforms:
    [
        Scale {x: bind sm_vars.saleman_field5_xCo, y: 1}
    ]
   onMouseEntered: function(e: MouseEvent):Void
   {
		sm_vars.saleman_field5_xCo = 2;
   }   
   onMouseExited: function(e: MouseEvent):Void
   {
		sm_vars.saleman_field5_xCo = 1;
   }
   onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			saleman_addsalesperson_Malegender.requestFocus();
		}
	}
}

def saleman_addsalesperson_gender = ToggleGroup {};
var saleman_addsalesperson_Malegender = RadioButton
{
        text: "Male"
		toggleGroup: saleman_addsalesperson_gender;
        layoutX: 350;
		layoutY: 250;
		transforms:
        [
            Scale {x: 1.2, y: 1.2}
        ]
		onKeyPressed: function(e: KeyEvent):Void
		{
			if(e.code.toString() == "VK_TAB")
			{
				saleman_addsalesperson_Femalegender.requestFocus();
			}
		}
}

var saleman_addsalesperson_Femalegender = RadioButton
{
    text: "Female"
	toggleGroup: saleman_addsalesperson_gender;
    layoutX: 420;
	layoutY: 250;
	transforms:
    [
        Scale {x: 1.2, y: 1.2}
    ]    
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			addsalespersonbirthyear.requestFocus();
		}
	}
}
var addsalespersonbirthdate = ChoiceBox
{
	layoutX: 435;
	layoutY: 310;
	items:bind ["   ",admin_vars.dd];
	disable: bind (addsalespersonbirthmonth.selectedIndex == -1);
	
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			saleman_addsalesperson_deptchoicebox.requestFocus();
		}
	}
}
for(k in [1975..2000])
{
    insert k.toString() into admin_vars.yy;
}
var addsalespersonbirthmonth : ChoiceBox;
addsalespersonbirthmonth = ChoiceBox
{
	layoutX: 350;
	layoutY: 310;
	items:["JAN","FEB","MAR","APR","MAY","JUNE","JULY","AUG","SEP","OCT","NOV","DEC"];
	disable: bind (addsalespersonbirthyear.selectedIndex == -1);
	
	onMouseExited: function(e: MouseEvent): Void
	{
		delete admin_vars.dd;
		if(addsalespersonbirthmonth.selectedItem.toString() == "FEB")
		{
			if(admin_vars.leap == "true")
			{
				for(i in [1..29] )
				{
					insert i.toString() into admin_vars.dd;
				}
			}
			else
			{
				for(i in [1..28] )
				{
					insert i.toString() into admin_vars.dd;
				}
			}
		}
		if(addsalespersonbirthmonth.selectedItem.toString() == "JAN" or addsalespersonbirthmonth.selectedItem.toString() == "MAR" or addsalespersonbirthmonth.selectedItem.toString() == "MAY" or addsalespersonbirthmonth.selectedItem.toString() == "JULY" or addsalespersonbirthmonth.selectedItem.toString() == "AUG" or addsalespersonbirthmonth.selectedItem.toString() == "OCT" or addsalespersonbirthmonth.selectedItem.toString() == "DEC")
		{
			for(i in [1..31] )
			{
				insert i.toString() into admin_vars.dd;
			}
		}
		if(addsalespersonbirthmonth.selectedItem.toString() == "APR" or addsalespersonbirthmonth.selectedItem.toString() == "JUNE" or addsalespersonbirthmonth.selectedItem.toString() == "SEP" or addsalespersonbirthmonth.selectedItem.toString() == "NOV")
		{
			for(i in [1..30] )
			{
				insert i.toString() into admin_vars.dd;
			}
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			addsalespersonbirthdate.requestFocus();
		}
	}
}
var addsalespersonbirthyear : ChoiceBox;
addsalespersonbirthyear = ChoiceBox
{
	id: "cb";
	layoutX: 385;
	layoutY: 280;
	scaleX: 1.9;
	items: bind [admin_vars.yy]
	
	onMouseExited: function(e: MouseEvent): Void
	{
		if(addsalespersonbirthyear.selectedItem.toString() != "")
		{
			var year: Integer = Integer.parseInt(addsalespersonbirthyear.selectedItem.toString());
			if((year mod 4) == 0)
			{
				admin_vars.leap = "true";
			}
			else
			{
				admin_vars.leap = "false";
			}
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			addsalespersonbirthmonth.requestFocus();
		}
	}
}
var saleman_addsalesperson_deptchoicebox = ChoiceBox
{
	layoutX: 375;
	layoutY: 340;
	scaleX: 1.5;                                        
	items: bind [admin_vars.dept_choicebox_item];
	layoutInfo: LayoutInfo { width: 100 };
	
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addsalesperson_phoneno_field.requestFocus();
		}
	}
}
sm_vars.saleman_addsalesperson_phoneno_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 350;
	layoutY: 370;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_phoneno_field.columns = 30;
		sm_vars.saleman_addsalesperson_phoneno_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_phoneno_field.columns = 20;
		sm_vars.saleman_addsalesperson_phoneno_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.add_sales_person == false)
		{
			sm_vars.saleman_addsalesperson_phoneno_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addsalesperson_email_field.requestFocus();
			sm_vars.saleman_addsalesperson_phoneno_field.text = sm_vars.saleman_addsalesperson_phoneno_field.text.trim();
		}
	}
}
sm_vars.saleman_addsalesperson_email_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 350;
	layoutY: 400;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_email_field.columns = 30;
		sm_vars.saleman_addsalesperson_email_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_email_field.columns = 20;
		sm_vars.saleman_addsalesperson_email_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.add_sales_person == false)
		{
			sm_vars.saleman_addsalesperson_email_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.saleman_addsalesperson_address_field.requestFocus();
			sm_vars.saleman_addsalesperson_email_field.text = sm_vars.saleman_addsalesperson_email_field.text.trim();
		}
	}
}
sm_vars.saleman_addsalesperson_address_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 3;
	layoutX: 350;
	layoutY: 430;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_address_field.columns = 30;
		sm_vars.saleman_addsalesperson_address_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.saleman_addsalesperson_address_field.columns = 20;
		sm_vars.saleman_addsalesperson_address_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.add_sales_person == false)
		{
			sm_vars.saleman_addsalesperson_address_field.text = "";
		}
	}
}
var scrollbar2 = ScrollBar
{
	var opacityfloat = 0.5;
	translateX: 980
	translateY: 310
    scaleX: 1.5
	scaleY: 5.2
    blockIncrement: 50
	unitIncrement:100
	min: 0
	max: 200
    visible:false
	vertical: true
	opacity:bind opacityfloat
    onMouseEntered: function(e: MouseEvent): Void
	{
        opacityfloat=1.0
    }
	onMouseExited: function(e: MouseEvent):Void
   {
		opacityfloat=0.5
   }
}
var selectedfilelabel2 = Label
{
	id: "label";
	text: "No File Selected.";
	layoutX: 500;
	layoutY: 490;
}
var underlbl = Label
{
	id: "label";
	text: bind sm_vars.saleman_unm_field.text;
	layoutX: 350;
	layoutY: 520;
}

var saleman_add_saleperson : Panel = Panel
{
	content : 
	[
		Panel
		{
			layoutX: 200,
			layoutY:bind -(scrollbar2.value)+100,
			height: 550,
			width: 800
			content:
			[
				Label
                    {
                        text: "Add Person";
                        layoutX: 300;
                        layoutY: 40;
                        font:Font.font("ARIAL", FontWeight.BOLD, 20);
                        effect:Glow {level:0.5};
                    }
				Label
				{
					id: "label";
					text: "First Name";
					layoutX: 240;
					layoutY: 100;
				}
				sm_vars.saleman_addsalesperson_fnm_field,
				Label
				{
					id: "label";
					text: "Middle Name";
					layoutX: 240;
					layoutY: 130;
				}
				sm_vars.saleman_addsalesperson_mnm_field,
				Label
				{
					id: "label";
					text: "Last Name";
					layoutX: 240;
					layoutY: 160;
				}
				sm_vars.saleman_addsalesperson_lnm_field,
				Label
				{
					id: "label";
					text: "User Name";
					layoutX: 240;
					layoutY: 190;
				}
				sm_vars.saleman_addsalesperson_unm_field,
				Label
				{
					id: "label";
					text: "Password";
					layoutX: 240;
					layoutY: 220;
				}
				saleman_addsalesperson_pass_field,
				Label
				{
					id: "label";
					text: "Gender";
					layoutX: 240;
					layoutY: 250;
				}
				saleman_addsalesperson_Malegender,
				saleman_addsalesperson_Femalegender,
                Label
				{
					id: "label";
					text: "Birthdate";
					layoutX: 240;
					layoutY: 280;
				}
				addsalespersonbirthdate,
				addsalespersonbirthmonth,
				addsalespersonbirthyear,
				Label
				{
					id: "label";
					text: "Department";
					layoutX: 240;
					layoutY: 340;
				}
				saleman_addsalesperson_deptchoicebox,
				Label
				{
					id: "label";
					text: "Phone No";
					layoutX: 240;
					layoutY: 370;
				}
				sm_vars.saleman_addsalesperson_phoneno_field,
				Label
				{
					id: "label";
					text: "Email ID";
					layoutX: 240;
					layoutY: 400;
				}
				sm_vars.saleman_addsalesperson_email_field,
				Label
				{
					id: "label";
					text: "Address";
					layoutX: 240;
					layoutY: 430;
				}
				sm_vars.saleman_addsalesperson_address_field,
				Label
				{
					id: "label";
					text: "Photo";
					layoutX: 240;
					layoutY: 490;
				}
				Button
				{
					text: "Choose File"
					layoutX: 350;
					layoutY: 490;					
					action: function()
					{
						var result = filechooser.showOpenDialog(null);
						var fileobj = filechooser.getSelectedFile();
						if(filechooser.APPROVE_OPTION == result)
						{
							if(fileobj.getName().endsWith(".jpg") or fileobj.getName().endsWith(".JPG"))
							{
								selectedfilelabel2.text = fileobj.getName();
								sm_vars.smimage = ImageIO.read(fileobj);
							}
							else
							{
								Alert.inform("Select JPEG files.");
								sm_vars.add_sales_person = false;
							}							
						}				
					}
				}
				selectedfilelabel2,
				Label
				{
					id: "label";
					text: "Under";
					layoutX: 240;
					layoutY: 520;
				}
				underlbl,
				Button
                    {
                        text: "Add";
                        layoutX: 350;
						layoutY: 550;
                        transforms:
                        [
                            Scale {x: 1.2, y: 1.2}
                        ]
                        action: function()
                        {
							sm_vars.add_sales_person = true;
							if(sm_vars.saleman_addsalesperson_fnm_field.text == "")
							{
								sm_vars.saleman_addsalesperson_fnm_field.text = "* First Name cannot be empty";
								sm_vars.add_sales_person = false;
							}
							if(sm_vars.saleman_addsalesperson_mnm_field.text == "")
							{
								sm_vars.saleman_addsalesperson_mnm_field.text = "* Middle Name cannot be empty";
								sm_vars.add_sales_person = false;
							}
							if(sm_vars.saleman_addsalesperson_lnm_field.text == "")
							{
								sm_vars.saleman_addsalesperson_lnm_field.text = "* Last Name cannot be empty";
								sm_vars.add_sales_person = false;
							}
							if(sm_vars.saleman_addsalesperson_unm_field.text == "")
							{
								sm_vars.saleman_addsalesperson_unm_field.text = "* User Name cannot be empty";
								sm_vars.add_sales_person = false;					
							}
							else
							{
								var check_rs: ResultSet = admin_vars.st.executeQuery("select * from salesman_master where username = '{sm_vars.saleman_addsalesperson_unm_field.text.toString()}'");
								if(check_rs.next())
								{
									sm_vars.add_sales_person = false;
									sm_vars.saleman_addsalesperson_unm_field.text = "* User Name already exists";
								}
							}
							if(saleman_addsalesperson_pass_field.text == "")
							{
								saleman_addsalesperson_pass_field.text = "";
								sm_vars.add_sales_person = false;
							}							
							if(sm_vars.saleman_addsalesperson_phoneno_field.text.length() < 10 or sm_vars.saleman_addsalesperson_phoneno_field.text.length() > 10)
							{
								sm_vars.saleman_addsalesperson_phoneno_field.text = "* Phone no must be 10 digits long.";
								sm_vars.add_sales_person = false;
							}
							else
							{
								matcher = admin_vars.phonepattern.matcher(sm_vars.saleman_addsalesperson_phoneno_field.text);
								if(matcher.matches())
								{
								}
								else
								{
									sm_vars.saleman_addsalesperson_phoneno_field.text = "* Invalid Phone no.";
									sm_vars.add_sales_person = false;
								}
							}							
							if(sm_vars.saleman_addsalesperson_email_field.text == "")
							{
								sm_vars.saleman_addsalesperson_email_field.text = "* Email cannot be empty";
								sm_vars.add_sales_person = false;								
							}							
							else 
							{
								matcher = admin_vars.pattern.matcher(sm_vars.saleman_addsalesperson_email_field.text);
								if(matcher.matches())
								{
								}
								else
								{
									sm_vars.saleman_addsalesperson_email_field.text = "* Email is not valid";
									sm_vars.add_sales_person = false;
								}
							}
							if(sm_vars.saleman_addsalesperson_address_field.text == "")
							{
								sm_vars.saleman_addsalesperson_address_field.text = "* Address cannot be empty";
								sm_vars.add_sales_person = false;
							}
							if(addsalespersonbirthdate.selectedIndex == -1 or addsalespersonbirthmonth.selectedIndex == -1 or addsalespersonbirthyear.selectedIndex == -1 or addsalespersonbirthdate.selectedItem == "")
							{
								Alert.inform("Select Birthdate.");
								sm_vars.add_sales_person = false;
							}
							if(saleman_addsalesperson_deptchoicebox.selectedIndex == -1)
							{
								Alert.inform("Select Department.");
								sm_vars.add_sales_person = false;
							}
							if(selectedfilelabel2.text == "No File Selected.")
							{
								Alert.inform("Select Photo.");
								sm_vars.add_sales_person = false;
							}
							if(sm_vars.add_sales_person == true)
							{
								admin_vars.cs = admin_vars.cn.prepareCall("call add_salesman_master(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
								admin_vars.cs.setString(1,'{sm_vars.saleman_addsalesperson_fnm_field.text}');
								admin_vars.cs.setString(2,'{sm_vars.saleman_addsalesperson_mnm_field.text}');
								admin_vars.cs.setString(3,'{sm_vars.saleman_addsalesperson_lnm_field.text}');
								admin_vars.cs.setString(4,'{sm_vars.saleman_addsalesperson_unm_field.text}');
								admin_vars.cs.setString(5,'{saleman_addsalesperson_pass_field.text}');
								admin_vars.cs.setString(6,'{(saleman_addsalesperson_gender.selectedToggle as RadioButton).text}');
								admin_vars.cs.setString(7,'{addsalespersonbirthdate.selectedItem}');
								admin_vars.cs.setString(8,'{addsalespersonbirthmonth.selectedItem}');
								admin_vars.cs.setString(9,'{addsalespersonbirthyear.selectedItem}');
								admin_vars.cs.setString(10,'{saleman_addsalesperson_deptchoicebox.selectedItem}');
								admin_vars.cs.setString(11,'{sm_vars.saleman_addsalesperson_phoneno_field.text}');
								admin_vars.cs.setString(12,'{sm_vars.saleman_addsalesperson_email_field.text}');
								admin_vars.cs.setString(13,'{sm_vars.saleman_addsalesperson_address_field.text}');
								admin_vars.cs.setString(14,'{underlbl.text}');
								admin_vars.cs.setString(15,"{sm_vars.saleman_addsalesperson_unm_field.text}.jpg");
								
								if(admin_vars.cs.executeUpdate() == 0)
								{
									var targetFile: File;
									targetFile = new File("../Person/userpic/{sm_vars.saleman_addsalesperson_unm_field.text}.jpg");
									ImageIO.write(sm_vars.smimage, "jpg", targetFile);
									
									var temp = "{sm_vars.saleman_addsalesperson_fnm_field.text} {sm_vars.saleman_addsalesperson_lnm_field.text}";
									insert temp into vars.mem_choicebox_item;
									insert "{sm_vars.saleman_addsalesperson_fnm_field.text} {sm_vars.saleman_addsalesperson_mnm_field.text} {sm_vars.saleman_addsalesperson_lnm_field.text}" into sm_vars.sp_name;	
									insert {sm_vars.saleman_addsalesperson_unm_field.text} into sm_vars.sp_unm;
									insert "{addsalespersonbirthdate.selectedItem}-{addsalespersonbirthmonth.selectedItem}-{addsalespersonbirthyear.selectedItem}" into sm_vars.sp_bdate;	
									insert "{saleman_addsalesperson_deptchoicebox.selectedItem}" into sm_vars.sp_dept;
									insert {sm_vars.saleman_addsalesperson_phoneno_field.text} into sm_vars.sp_phoneno;
									insert {sm_vars.saleman_addsalesperson_email_field.text} into sm_vars.sp_email;
									sm_vars.lv_per_size = 30 * sm_vars.sp_unm.size();
									Alert.inform("Person Data inserted successfully.");									
									addsalesperson_value_null();
								}
                            }
                        }
                    }
			]
		}
	]
	visible:false;
}

// View Persons

sm_vars.viewPersonLabels = ListView
{
	layoutInfo: LayoutInfo{width: 750 height: 30}
	layoutX: 20
	layoutY: 100
	visible: bind not (sm_vars.viewPersonListView.height == 0)
	cellFactory: function() {
        var listCell: ListCell = ListCell
		{
			node : HBox {
				content: [
                    VBox {
					layoutInfo: LayoutInfo{width: 100}
			        spacing: 10
                    content: [
                        Label {
							id: "lbl2"
                            text: "User Name"
                            visible: bind not (sm_vars.viewPersonListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 150}
			        spacing: 10
                    content: [
                        Label {
							id: "lbl2"
                            text: "Name"
                            visible: bind not (sm_vars.viewPersonListView.height == 0)
						}
                    ]
					}					
					VBox {
					layoutInfo: LayoutInfo{width: 110}
			        spacing: 10
                    content: [
                        Label {
							id: "lbl2"
                            text: "Birthday"
                            visible: bind not (sm_vars.viewPersonListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 50}
			        spacing: 10
                    content: [
                        Label {
							id: "lbl2"
                            text: "Dept."
                            visible: bind not (sm_vars.viewPersonListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 100}
			        spacing: 10
                    content: [
                        Label {
							id: "lbl2"
                            text: "Phone No."
                            visible: bind not (sm_vars.viewPersonListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 160}
			        spacing: 10
                    content: [
                        Label {
							id: "lbl2"
                            text: "Email"
                            visible: bind not (sm_vars.viewPersonListView.height == 0)
						}
                    ]
					}
					VBox {
					layoutInfo: LayoutInfo{width: 70}
			        spacing: 10
                    content: [          
						Label {
							id: "lbl2"
                            text: "Delete"
                            visible: bind not (sm_vars.viewPersonListView.height == 0)
						}
                    ]
					}
				]
			}
		}
	}
}
sm_vars.viewPersonListView = ListView {
        items: bind [sm_vars.sp_unm]
		layoutInfo: LayoutInfo{height:bind sm_vars.lv_per_size width: 750}
		layoutX: 20
		layoutY: 150
		
        cellFactory: function() {
            var listCell: ListCell;           
			
			if(sm_vars.sp_unm.size() > 5)
            {
                sm_vars.lv_per_size = 30 * 5;
            }
            else
            {
                sm_vars.lv_per_size = 30 * sm_vars.sp_unm.size();
            }
            listCell = ListCell {
                node : HBox {
					content: [
                         VBox {
							layoutInfo: LayoutInfo{width: 100}
			                spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.sp_unm[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_per_flag or not listCell.selected or (sm_vars.lv_per_ind != listCell.index)
                                }                                
                            ]
                        }
                         VBox {
							layoutInfo: LayoutInfo{width: 150}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.sp_name[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_per_flag or not listCell.selected or (sm_vars.lv_per_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 110}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.sp_bdate[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_per_flag or not listCell.selected or (sm_vars.lv_per_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 50}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.sp_dept[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_per_flag or not listCell.selected or (sm_vars.lv_per_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.sp_phoneno[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_per_flag or not listCell.selected or (sm_vars.lv_per_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 160}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind sm_vars.sp_email[listCell.index]
                                    visible: bind not listCell.empty and not sm_vars.lv_per_flag or not listCell.selected or (sm_vars.lv_per_ind != listCell.index)
                                }                  
                            ]
                        }
					    VBox{
							layoutInfo: LayoutInfo{width: 70}
                            spacing: 10
                            content: [
                                Button {
                                    vpos: VPos.TOP;
                                    text: "Delete"
                                    visible: bind not listCell.empty and (not sm_vars.lv_per_flag or not listCell.selected or (sm_vars.lv_per_ind != listCell.index))
                                    action: function() {
                                        admin_vars.cs = admin_vars.cn.prepareCall("call delete_person(?)");
                                        admin_vars.cs.setString(1,'{sm_vars.sp_unm[listCell.index]}');
                                        admin_vars.cs.executeUpdate();
                                        delete sm_vars.sp_unm[listCell.index] from sm_vars.sp_unm;
                                        delete sm_vars.sp_name[listCell.index] from sm_vars.sp_name;
										delete sm_vars.sp_bdate[listCell.index] from sm_vars.sp_bdate;
                                        sm_vars.sp_dept[listCell.index] = "";
										delete "" from sm_vars.sp_dept;
										delete sm_vars.sp_phoneno[listCell.index] from sm_vars.sp_phoneno;
                                        delete sm_vars.sp_email[listCell.index] from sm_vars.sp_email;
										sm_vars.lv_per_size = 30 * sm_vars.sp_unm.size();
                                    }
                                }
                            ]
                        }
                        ]
                        }            
            }
        }
        visible:true;
    };
	
sm_vars.salesmanager_view_person = Panel
{
	content : 
	[
		Panel
		{
			layoutX: 200,
			layoutY: 100,
			height: 550,
			width: 800
			content:
			[
				Label
                {
                    text: "Persons";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
				{
					text: "You have not added any persons yet.";
                    layoutX: 220;
                    layoutY: 150;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (sm_vars.viewPersonListView.height == 0)
				}
				sm_vars.viewPersonLabels,
				sm_vars.viewPersonListView,
			]
		}
	]
	visible: false;
}

// Edit Profile
sm_vars.sm_fnm = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 300;
	layoutY: 100;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.sm_fnm.columns = 30;
		sm_vars.sm_fnm.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.sm_fnm.columns = 20;
		sm_vars.sm_fnm.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.sm_error == false)
		{
			sm_vars.sm_fnm.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.sm_mnm.requestFocus();
			sm_vars.sm_fnm.text = sm_vars.sm_fnm.text.trim();
		}
	}
}
sm_vars.sm_mnm = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 300;
	layoutY: 130;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.sm_mnm.columns = 30;
		sm_vars.sm_mnm.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.sm_mnm.columns = 20;
		sm_vars.sm_mnm.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.sm_error == false)
		{
			sm_vars.sm_mnm.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.sm_lnm.requestFocus();
			sm_vars.sm_mnm.text = sm_vars.sm_mnm.text.trim();
		}
	}
}
sm_vars.sm_lnm = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 300;
	layoutY: 160;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.sm_lnm.columns = 30;
		sm_vars.sm_lnm.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.sm_lnm.columns = 20;
		sm_vars.sm_lnm.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.sm_error == false)
		{
			sm_vars.sm_lnm.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.sm_byear.requestFocus();
			sm_vars.sm_lnm.text = sm_vars.sm_lnm.text.trim();
		}
	}
}
sm_vars.sm_bdate = ChoiceBox
{
	layoutX: 385
	layoutY: 220
	items: bind ["  ",admin_vars.dd]
	disable: bind (sm_vars.sm_bmon.selectedIndex == -1)
}
sm_vars.sm_bmon = ChoiceBox
{
	layoutX: 300
	layoutY: 220
	items: ["JAN","FEB","MAR","APR","MAY","JUNE","JULY","AUG","SEP","OCT","NOV","DEC"]
	disable: bind (sm_vars.sm_byear.selectedIndex == -1)
	
	onMouseExited: function(e: MouseEvent): Void
	{
		delete admin_vars.dd;
		if(sm_vars.sm_bmon.selectedItem.toString() == "FEB")
		{
			if(admin_vars.leap == "true")
			{
				for(i in [1..29] )
				{
					insert i.toString() into admin_vars.dd;
				}
			}
			else
			{
				for(i in [1..28] )
				{
					insert i.toString() into admin_vars.dd;
				}
			}
		}
		if(sm_vars.sm_bmon.selectedItem.toString() == "JAN" or sm_vars.sm_bmon.selectedItem.toString() == "MAR" or sm_vars.sm_bmon.selectedItem.toString() == "MAY" or sm_vars.sm_bmon.selectedItem.toString() == "JULY" or sm_vars.sm_bmon.selectedItem.toString() == "AUG" or sm_vars.sm_bmon.selectedItem.toString() == "OCT" or sm_vars.sm_bmon.selectedItem.toString() == "DEC")
		{
			for(i in [1..31] )
			{
				insert i.toString() into admin_vars.dd;
			}
		}
		if(sm_vars.sm_bmon.toString() == "APR" or sm_vars.sm_bmon.selectedItem.toString() == "JUNE" or sm_vars.sm_bmon.selectedItem.toString() == "SEP" or sm_vars.sm_bmon.selectedItem.toString() == "NOV")
		{
			for(i in [1..30] )
			{
				insert i.toString() into admin_vars.dd;
			}
		}
	}
}
sm_vars.sm_byear = ChoiceBox
{
	layoutX: 335
	layoutY: 190
	items: bind [admin_vars.yy]
	scaleX: 1.9
	onMouseExited: function(e: MouseEvent): Void
	{
		if(vars.act_date_y.selectedItem.toString() != "")
		{
			var year: Integer = Integer.parseInt(vars.act_date_y.selectedItem.toString());
			if((year mod 4) == 0)
			{
				admin_vars.leap = "true";
			}
			else
			{
				admin_vars.leap = "false";
			}
		}
	}
}
sm_vars.sm_phno = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 300;
	layoutY: 250;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.sm_phno.columns = 30;
		sm_vars.sm_phno.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.sm_phno.columns = 20;
		sm_vars.sm_phno.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.sm_error == false)
		{
			sm_vars.sm_phno.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.sm_email.requestFocus();
			sm_vars.sm_phno.text = sm_vars.sm_phno.text.trim();
		}
	}
}
sm_vars.sm_email = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 300;
	layoutY: 280;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.sm_email.columns = 30;
		sm_vars.sm_email.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.sm_email.columns = 20;
		sm_vars.sm_email.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.sm_error == false)
		{
			sm_vars.sm_email.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.sm_add.requestFocus();
			sm_vars.sm_email.text = sm_vars.sm_email.text.trim();
		}
	}
}
sm_vars.sm_add = TextBox
{
	columns: 20;
	multiline: true;
	lines: 3;
	layoutX: 300;
	layoutY: 310;
	onMouseEntered: function(e: MouseEvent):Void
    {
		sm_vars.sm_add.columns = 30;
		sm_vars.sm_add.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		sm_vars.sm_add.columns = 20;
		sm_vars.sm_add.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(sm_vars.sm_error == false)
		{
			sm_vars.sm_add.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			sm_vars.sm_pic.requestFocus();
			sm_vars.sm_add.text = sm_vars.sm_add.text.trim();
		}
	}
}
sm_vars.sm_pic = ImageView {    
    x: 550
	y: 100
	fitWidth: 200
	fitHeight: 150
}
sm_vars.sm_picbtn = Button {
	text: "Choose File"
	layoutX: 600
	layoutY: 265
	
	action: function()
	{
		var result = filechooser.showOpenDialog(null);
		var fileobj = filechooser.getSelectedFile();
		if(filechooser.APPROVE_OPTION == result)
		{
			if(fileobj.getName().endsWith(".jpg") or fileobj.getName().endsWith(".JPG"))
			{
				sm_vars.sm_piclbl.text = fileobj.getName();
				admin_vars.image = ImageIO.read(fileobj);
			}
			else
			{
				Alert.inform("Select JPEG files.");
			}							
		}
	}
}
sm_vars.sm_piclbl = Label
{
	id: "label"
	text: "No File Selected"
	layoutX: 550
	layoutY: 300
}
admin_vars.EMAIL_PATTERN = "^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+$";
admin_vars.pattern = Pattern.compile(admin_vars.EMAIL_PATTERN);

admin_vars.PHONE_PATTERN = "^[0-9]+$"; //new 19-04
admin_vars.phonepattern = Pattern.compile(admin_vars.PHONE_PATTERN);

sm_vars.sm_edit_profile = Panel
{
	content : 
	[
		Panel
		{
			layoutX: 200,
			layoutY: 100,
			height: 550,
			width: 800
			content:
			[
				Label
                {
                    text: "Edit Profile";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
				{
					id: "label";
					text: "First Name";
					layoutX: 190;
					layoutY: 100;
				}
				sm_vars.sm_fnm,
				Label
				{
					id: "label";
					text: "Middle Name";
					layoutX: 190;
					layoutY: 130;
				}
				sm_vars.sm_mnm,
				Label
				{
					id: "label";
					text: "Last Name";
					layoutX: 190;
					layoutY: 160;
				}
				sm_vars.sm_lnm,
				Label
				{
					id: "label";
					text: "Birthdate";
					layoutX: 190;
					layoutY: 190;
				}
				sm_vars.sm_bdate,sm_vars.sm_bmon,sm_vars.sm_byear,
				Label
				{
					id: "label";
					text: "Phone No.";
					layoutX: 190;
					layoutY: 250;
				}
				sm_vars.sm_phno,
				Label
				{
					id: "label";
					text: "Email";
					layoutX: 190;
					layoutY: 280;
				}
				sm_vars.sm_email,
				Label
				{
					id: "label";
					text: "Address";
					layoutX: 190;
					layoutY: 310;
				}
				sm_vars.sm_add,
				sm_vars.sm_pic,
				sm_vars.sm_picbtn,
				sm_vars.sm_piclbl,
				Button
                    {
                        text: "Update";
                        layoutX: 300;
						layoutY: 380;
                        transforms:
                        [
                            Scale {x: 1.2, y: 1.2}
                        ]
                        action: function()
                        {
							sm_vars.sm_error = true;
							if(sm_vars.sm_fnm.text == "")
							{
								sm_vars.sm_fnm.text = "* First Name cannot be empty";
								sm_vars.sm_error = false;
							}
							if(sm_vars.sm_mnm.text == "")
							{
								sm_vars.sm_mnm.text = "* Middle Name cannot be empty";
								sm_vars.sm_error = false;
							}
							if(sm_vars.sm_lnm.text == "")
							{
								sm_vars.sm_lnm.text = "* Last Name cannot be empty";
								sm_vars.sm_error = false;
							}
							if(sm_vars.sm_bdate.selectedIndex == -1 or sm_vars.sm_bmon.selectedIndex == -1 or sm_vars.sm_byear.selectedIndex == -1 or sm_vars.sm_bdate.selectedItem == "  ")
							{
								Alert.inform("Select Birthdate.");
								sm_vars.sm_error = false;
							}							
							if(sm_vars.sm_phno.text.length() < 10 or sm_vars.sm_phno.text.length() > 10)
							{
								sm_vars.sm_phno.text = "* Phone no must be 10 digits long.";
								sm_vars.sm_error = false;
							}
							else
							{
								matcher = admin_vars.phonepattern.matcher(sm_vars.sm_phno.text);
								if(not matcher.matches())
								{
									sm_vars.sm_phno.text = "* Invalid Phone no.";
									sm_vars.sm_error = false;
								}
							}							
							if(sm_vars.sm_email.text == "")
							{
								sm_vars.sm_email.text = "* Email cannot be empty";
								sm_vars.sm_error = false;								
							}							
							else 
							{
								matcher = admin_vars.pattern.matcher(sm_vars.sm_email.text);
								if(not matcher.matches())
								{
									sm_vars.sm_email.text = "* Email is not valid";
									sm_vars.sm_error = false;
								}
							}
							if(sm_vars.sm_add.text == "")
							{
								sm_vars.sm_add.text = "* Address cannot be empty";
								sm_vars.sm_error = false;
							}
							if(sm_vars.sm_piclbl.text == "No File Selected")
							{
								Alert.inform("Select JPEG File.");
								sm_vars.sm_error = false;
							}
							if(sm_vars.sm_error == true)
							{
								admin_vars.cs = admin_vars.cn.prepareCall("call update_manager(?,?,?,?,?,?,?,?,?,?,?)");
								admin_vars.cs.setString(1,'{sm_vars.saleman_unm_field.text}');
								admin_vars.cs.setString(2,'{sm_vars.sm_fnm.text}');
								admin_vars.cs.setString(3,'{sm_vars.sm_mnm.text}');
								admin_vars.cs.setString(4,'{sm_vars.sm_lnm.text}');
								admin_vars.cs.setString(5,'{sm_vars.sm_bdate.selectedItem}');
								admin_vars.cs.setString(6,'{sm_vars.sm_bmon.selectedItem}');
								admin_vars.cs.setString(7,'{sm_vars.sm_byear.selectedItem}');
								admin_vars.cs.setString(8,'{sm_vars.sm_phno.text}');
								admin_vars.cs.setString(9,'{sm_vars.sm_email.text}');
								admin_vars.cs.setString(10,'{sm_vars.sm_add.text}');
								admin_vars.cs.setString(11,"{sm_vars.saleman_unm_field.text}.jpg");
								
								if(admin_vars.cs.executeUpdate() == 0)
								{
									var targetFile: File;
									targetFile = new File("userpic/{sm_vars.saleman_unm_field.text}.jpg");
									ImageIO.write(admin_vars.image, "jpg", targetFile);
									
									Alert.inform("Manager Data updated successfully.");									
									sm_vars.sm_pic.image = Image{url: "{__DIR__}/userpic/{sm_vars.saleman_unm_field.text}.jpg"};
									sm_vars.sm_byear.clearSelection();
									sm_vars.sm_bmon.clearSelection();
									sm_vars.sm_bdate.clearSelection();
								}
							}				
							
                        }
                    }
			]
		}
	]
	visible: false;
}

// Stage and Scene

var img1 = ImageView
{
	x: 210;
	y: 110;
	id: "image";
	image: Image
	{
		width: 300;
		height: 250;
		url: "{__DIR__}1.jpg";
	}
}

var img2 = ImageView
{
	x: 680;
	y: 360;
	image: Image
	{
		width: 300;
		height: 250;
		url: "{__DIR__}3.jpg";
	}
}

var trans = SequentialTransition
{
	node: img1;
	
	content: 
	[
		TranslateTransition { duration: 10s fromX: 0 toX: 480}
		TranslateTransition { duration: 5s fromY: 0 toY: 250}
		TranslateTransition { duration: 10s fromX: 480 toX: 0}
		TranslateTransition { duration: 5s fromY: 250 toY: 0}
	]
}
trans.play();

var trans2 = SequentialTransition
{
	node: img2;
	
	content: 
	[
		TranslateTransition { duration: 10s fromX: 0 toX: -480}
		TranslateTransition { duration: 5s fromY: 0 toY: -250}
		TranslateTransition { duration: 10s fromX: -480 toX: 0}
		TranslateTransition { duration: 5s fromY: -250 toY: 0}
	]
}
trans2.play();

// SCENES

// Main Scene

var mainscene : Scene;
mainscene = Scene {
		fill: Color.LAVENDERBLUSH;				
		stylesheets: ["{__DIR__}sams.css"]
        content: [
            sm_vars.salesmanager,
            ImageView
            {
                x:0;
                y:0;
                image:Image
                {
                   width:1000;
                   height:100;
                   url:"{__DIR__}logo.JPG";
                }
            }
			Rectangle
            {
                x: 0, y: 100
                width: 200, height: 540
                fill: Color.LAVENDER
            }			
			
            main_side_panel,
			img1,img2,
        ]
    }

// Sales Manager Scene

var salesmanager_scene = Scene {
		fill: Color.LAVENDERBLUSH;				
		stylesheets: ["{__DIR__}sams.css"]
        content: [
            sm_vars.saleman_assign_targets,sm_vars.saleman_add_company,saleman_add_client,saleman_add_saleperson,scrollbar2,sm_vars.salesmanager_view_person,sm_vars.salesmanager_view_company,
			sm_vars.sm_edit_profile,sm_vars.salesmanager_view_client,sm_vars.sm_view_target,sm_vars.salesmanager_add_stock,sm_vars.salesmanager_view_stock,
			sm_vars.sm_afterlogin,sm_vars.sm_prevsales,
            ImageView
            {
                x:0;
                y:0;
                image:Image
                {
                   width:1000;
                   height:100;
                   url:"{__DIR__}logo.JPG";
                }
            }
			Rectangle
            {
                x: 0, y: 100
                width: 200, height: 540
                fill: Color.LAVENDER
            }			
			
            sm_vars.salesmanager_side_panel,
        ]
    }
	
var sceneholder : Scene = mainscene;
	
Stage {
    title : "Sales And Marketing Management System";
	width : 1000;
	height : 650;
    resizable: false;
    scene: bind sceneholder
}