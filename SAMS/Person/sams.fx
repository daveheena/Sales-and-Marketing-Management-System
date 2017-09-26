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
import sp_variables.*;
import admin_variables.*;
import javafx.date.DateTime;
import java.text.SimpleDateFormat;

var vars = new sp_variables();
var admin_vars = new admin_variables();
var filechooser = new JFileChooser();

var matcher: Matcher;
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
for(k in [1975..2013])
{
    insert k.toString() into admin_vars.yy;
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
						text: "Person"
						layoutX: 30;
						layoutY: 120;
						action: function()
						{
							salesperson.visible = true;							
							img1.visible = false;
							img2.visible = false;
							vars.saleper_unm_field.text = "";
							vars.saleper_pass_field.text = "";
							admin_vars.msg = "";
						}
					}
				]
			}
	]
	visible:true;
}

// Sales Person side panel

function get_members_list() //7-4-2013
{
	delete vars.mem_choicebox_item;
	vars.salesper_add_act.visible = true;
	vars.salesper_rs1 = admin_vars.st.executeQuery("select UNDER from salesman_master where USERNAME='{vars.saleper_unm_field.text}'");
	if(vars.salesper_rs1.next())
	{
		vars.salesper_rs = admin_vars.st.executeQuery("select FIRST_NAME, LAST_NAME from SALESMAN_MASTER where UNDER='{vars.salesper_rs1.getString(1).toString()}' and USERNAME != '{vars.saleper_unm_field.text}'" );
		while(vars.salesper_rs.next())
		{
			var temp = "{vars.salesper_rs.getString(1).toString()} {vars.salesper_rs.getString(2).toString()}";
			insert temp into vars.mem_choicebox_item;
		}
	}
}

function add_activity_null()
{
	vars.mem_selected_item = "";
	vars.act_name.text = "";
	vars.act_for.text = "";
	vars.act_detail.text = "";
	vars.act_detail.text = "";
	vars.act_type.clearSelection();
	vars.act_date_y.clearSelection();
	vars.act_date_m.clearSelection();
	vars.act_date_d.clearSelection();
	delete vars.selectedmem_choicebox_item;
}

function add_lead_null()
{
	vars.add_lead_type.clearSelection();
	vars.add_lead_client.clearSelection();
	vars.add_lead_date.clearSelection();
	vars.add_lead_month.clearSelection();
	vars.add_lead_year.clearSelection();
	vars.add_lead_detail.text = "";
}

function add_sell_null()
{
	vars.add_sell_client.clearSelection();
	vars.add_sell_product.clearSelection();
	vars.add_sell_qty.text = "";
}
function salesperson_visible_false()
{
	vars.salesper_add_lead.visible = false;
	vars.salesper_new_sell.visible = false;
	vars.salesper_add_act.visible = false;	
	vars.actscrollbar.visible = false;
	vars.salesperson_view_target.visible = false;
	vars.sp_edit_profile.visible = false;
	vars.person_view_activities.visible = false;
	vars.person_view_leads.visible = false;
	vars.per_afterlogin.visible = false;
}
vars.salesperson_side_panel = Panel
{
	content : 
	[
		Panel
		{
			content:
			[
				Hyperlink
				{
						text: "Add Activity"
						layoutX: 30;
						layoutY: 120;
						action: function()
						{
							salesperson_visible_false();
							get_members_list();
							vars.salesper_add_act.visible = true;
							vars.actscrollbar.visible = true;							
							add_activity_null();
						}
				}
				Hyperlink
				{
						text: "View Activities"
						layoutX: 30;
						layoutY: 150;
						action: function()
						{
							salesperson_visible_false();
							vars.person_view_activities.visible = true;
							myact = true;
							otheract = true;
							vars.view_act_year.clearSelection();
							vars.view_act_fyear.clearSelection();
							vars.view_act_oyear.clearSelection();
							vars.view_act_ofyear.clearSelection();
						}
				}
				Hyperlink
				{
						text: "Add Lead"
						layoutX: 30;
						layoutY: 180;
						action: function()
						{
							salesperson_visible_false();
							add_lead_null();
							vars.salesper_add_lead.visible = true;
						}
			   }
			   Hyperlink
				{
						text: "View Leads"
						layoutX: 30;
						layoutY: 210;
						action: function()
						{
							salesperson_visible_false();
							vars.person_view_leads.visible = true;
							mylead = true;
							otherlead = true;
							vars.view_lead_year.clearSelection();
							vars.view_lead_fyear.clearSelection();
							vars.view_lead_oyear.clearSelection();
							vars.view_lead_ofyear.clearSelection();
						}
			   }
			   Hyperlink
				{
						text: "New Sell"
						layoutX: 30;
						layoutY: 240;
						action: function()
						{
							salesperson_visible_false();
							vars.salesper_new_sell.visible = true;														
							delete vars.add_sell_Client_item;
							delete vars.add_sell_product_item;
							vars.add_sell_Client_rs = admin_vars.st.executeQuery("select CL_FIRST_NAME,CL_LAST_NAME from CLIENT_MASTER");
							while(vars.add_sell_Client_rs.next())
							{
								insert "{vars.add_sell_Client_rs.getString(1).toString()} {vars.add_sell_Client_rs.getString(2).toString()}" into vars.add_sell_Client_item;							
							}

							vars.add_sell_product_rs = admin_vars.st.executeQuery("select NAME from PRODUCT_MASTER");
							while(vars.add_sell_product_rs.next())
							{
								insert vars.add_sell_product_rs.getString(1).toString() into vars.add_sell_product_item;							
							}
						}
				}
				Hyperlink
				{
						text: "View Target"
						layoutX: 30;
						layoutY: 270;
						action: function()
						{
							salesperson_visible_false();
							vars.salesperson_view_target.visible = true;
							delete vars.myTarget;
							delete vars.myDueDate;
							admin_vars.rs1 = admin_vars.st.executeQuery("select * from SALESMAN_MASTER where USERNAME='{vars.saleper_unm_field.text}'");
							if(admin_vars.rs1.next() and {admin_vars.rs1.getString(17).toString()} != "")
							{
								insert "{admin_vars.rs1.getString(17).toString()}" into vars.myTarget;	
								insert "{admin_vars.rs1.getString(19).toString()}-{admin_vars.rs1.getString(20).toString()}-{admin_vars.rs1.getString(21).toString()}" into vars.myDueDate;	
							}
							vars.lv_myTar_size = 30 * vars.myTarget.size();
						}
				}
				Hyperlink
				{
						text: "Edit Profile"
						layoutX: 30;
						layoutY: 300;
						action: function()
						{
							salesperson_visible_false();
							vars.sp_edit_profile.visible = true;
							vars.sp_fnm.text = "";
							vars.sp_mnm.text = "";
							vars.sp_lnm.text = "";
							vars.sp_phno.text = "";
							vars.sp_email.text = "";
							vars.sp_add.text = "";
							admin_vars.rs1 = admin_vars.st.executeQuery("select * from salesman_master where username='{vars.saleper_unm_field.text}'");
							if(admin_vars.rs1.next())
							{
								vars.sp_fnm.text = "{admin_vars.rs1.getString(2)}";
								vars.sp_mnm.text = "{admin_vars.rs1.getString(3)}";
								vars.sp_lnm.text = "{admin_vars.rs1.getString(4)}";								
								vars.sp_phno.text = "{admin_vars.rs1.getString(12)}";
								vars.sp_email.text = "{admin_vars.rs1.getString(13)}";
								vars.sp_add.text = "{admin_vars.rs1.getString(14)}";
								vars.sp_pic.image = Image{url: "{__DIR__}/userpic/{vars.saleper_unm_field.text}.jpg"};
							}
							vars.sp_byear.clearSelection();
							vars.sp_bmon.clearSelection();
							vars.sp_bdate.clearSelection();
						}
				}
				Hyperlink
				{
						text: "Logout"
						layoutX: 30;
						layoutY: 330;
						action: function()
						{
							salesperson_visible_false();
							vars.salesperson_side_panel.visible = false;
							sceneholder = mainscene;
							salesperson.visible = true;
							vars.saleper_unm_field.text= "";
							vars.saleper_pass_field.text = "";
							vars.mem_selected_item = "";
							main_side_panel.visible = true;						
							admin_vars.msg = "";
						}
				}
			]
		}
	]
	visible:false;
}

// Sales Person

// Main Panel

vars.saleper_unm_field = TextBox
{
	columns: 20;
	layoutX: 350;
	layoutY: 100;
	multiline:true;
	lines:1;
	
	onMouseEntered: function(e: MouseEvent):Void
	{
		vars.saleper_unm_field.columns = 30;
		vars.saleper_unm_field.translateX = 10;
	}   
	onMouseExited: function(e: MouseEvent):Void
	{
		vars.saleper_unm_field.columns = 20;
		vars.saleper_unm_field.translateX = 1;
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			vars.saleper_pass_field.requestFocus();
			vars.saleper_unm_field.text = vars.saleper_unm_field.text.trim();
		}
	}
}

vars.saleper_pass_field = PasswordBox
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
		vars.saleper_pass_field.translateX = 10;
	}   
	onMouseExited: function(e: MouseEvent):Void
	{
		admin_vars.xCo = 1;
		vars.saleper_pass_field.translateX = 1;
	}
}

var salesperson : Panel;
salesperson = Panel
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
                        text: "Person";
                        layoutX: 300;
                        layoutY: 40;
                        font:Font.font("ARIAL", FontWeight.BOLD, 20);
                        effect:Glow {level:0.5};
                    }
                    Label
                    {
						id: "label";
                        text: "Username";
                        layoutX: 240;
                        layoutY: 100;                        
                    }
                    vars.saleper_unm_field,
                    Label
                    {
						id: "label";
                        text: "Password";
                        layoutX: 240;
                        layoutY: 130;                        
                    }
                    vars.saleper_pass_field,
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
							admin_vars.cs = admin_vars.cn.prepareCall("call sales_person_login(?,?,?)");
							admin_vars.cs.setString(1,'{vars.saleper_unm_field.text}');
							admin_vars.cs.registerOutParameter(2,Types.VARCHAR);
							admin_vars.cs.registerOutParameter(3,Types.VARCHAR);
							admin_vars.cs.execute();
							
							if(vars.saleper_unm_field.text == "")
							{
								admin_vars.msg = "* Username field cannot be empty";
							}
							else if(admin_vars.cs.getString(2).equals(vars.saleper_unm_field.text))
                            {
								if(admin_vars.cs.getString(3).equals(vars.saleper_pass_field.text))
								{
								    salesperson.visible = false;
									main_side_panel.visible = false;
									sceneholder = salesperson_scene;
									vars.salesperson_side_panel.visible = true;													
									vars.per_afterlogin.visible = true;
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
                            vars.saleper_unm_field.text = "";
                            vars.saleper_pass_field.text = "";
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

// Person Main Page

vars.per_afterlogin = Panel
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
                    text: bind "Welcome {vars.saleper_unm_field.text}";
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

// Add Activity

vars.act_type = ChoiceBox
{
	items: ["Campaigns","Launch of New Product","Seminar"]
	layoutX: 348;
	layoutY: 100;
	scaleX: 0.83;
	layoutInfo: LayoutInfo { width: 180 };
	
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			vars.act_name.requestFocus();
		}
	}
}

vars.act_name = TextBox
{
	columns: 20;
	layoutX: 360;
	layoutY: 130;
	multiline: true;
	lines: 1;
	onMouseEntered: function(e: MouseEvent):Void
    {
		vars.act_name.columns = 30;
		vars.act_name.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		vars.act_name.columns = 20;
		vars.act_name.translateX = 1;
    }
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			vars.act_for.requestFocus();
			vars.act_name.text = vars.act_name.text.trim();
		}
	}
}

vars.act_for = TextBox
{
	columns: 20;
	layoutX: 360;
	layoutY: 160;
	multiline: true;
	lines: 1;
	onMouseEntered: function(e: MouseEvent):Void
    {
		vars.act_for.columns = 30;
		vars.act_for.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		vars.act_for.columns = 20;
		vars.act_for.translateX = 1;
    }
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			vars.act_date_y.requestFocus();
			vars.act_for.text = vars.act_for.text.trim();
		}
	}
}

vars.act_date_d = ChoiceBox
{
	layoutX: 445;
	layoutY: 220;
	items:bind ["   ",admin_vars.dd];
	disable: bind (vars.act_date_m.selectedIndex == -1);
	
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			vars.act_detail.requestFocus();
		}
	}
}
vars.act_date_m = ChoiceBox
{
	layoutX: 360;
	layoutY: 220;
	items:["JAN","FEB","MAR","APR","MAY","JUNE","JULY","AUG","SEP","OCT","NOV","DEC"];
	disable: bind (vars.act_date_y.selectedIndex == -1);
	
	onMouseExited: function(e: MouseEvent): Void
	{
		delete admin_vars.dd;
		if(vars.act_date_m.selectedItem.toString() == "FEB")
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
		if(vars.act_date_m.selectedItem.toString() == "JAN" or vars.act_date_m.selectedItem.toString() == "MAR" or vars.act_date_m.selectedItem.toString() == "MAY" or vars.act_date_m.selectedItem.toString() == "JULY" or vars.act_date_m.selectedItem.toString() == "AUG" or vars.act_date_m.selectedItem.toString() == "OCT" or vars.act_date_m.selectedItem.toString() == "DEC")
		{
			for(i in [1..31] )
			{
				insert i.toString() into admin_vars.dd;
			}
		}
		if(vars.act_date_m.selectedItem.toString() == "APR" or vars.act_date_m.selectedItem.toString() == "JUNE" or vars.act_date_m.selectedItem.toString() == "SEP" or vars.act_date_m.selectedItem.toString() == "NOV")
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
			vars.act_date_d.requestFocus();
		}
	}
}
vars.act_date_y = ChoiceBox
{
	id: "cb";
	layoutX: 395;
	layoutY: 190;
	scaleX: 1.9;
	items:[admin_vars.yr]
	
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
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			vars.act_date_m.requestFocus();
		}
	}
}

vars.act_detail = TextBox
{
	columns: 20;
	layoutX: 360;
	layoutY: 250;
	multiline: true;
	lines: 2;
	onMouseEntered: function(e: MouseEvent):Void
    {
		vars.act_detail.columns = 30;
		vars.act_detail.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		vars.act_detail.columns = 20;
		vars.act_detail.translateX = 1;
    }	
}

vars.act_leader = Label
{
	id: "label";
	text: bind vars.saleper_unm_field.text;
	layoutX: 360;
	layoutY: 300;
}

vars.act_members = ListView {
	layoutX: 360;
	layoutY: 330;
    items:bind [vars.mem_choicebox_item]
    layoutInfo: LayoutInfo { width: 150 height: 80 }
	disable: bind (vars.mem_choicebox_item.size() == 0);
	
	onMouseClicked: function(e: MouseEvent):Void
    {
		if(vars.act_members.selectedItem.toString() != "")
		{
			insert vars.act_members.selectedItem.toString() into vars.selectedmem_choicebox_item;
			delete vars.act_members.selectedItem.toString() from vars.mem_choicebox_item;
		}
    }  
}

vars.act_selected_members = ListView {
	layoutX: 360;
	layoutY: 420;
    items:bind [vars.selectedmem_choicebox_item]
    layoutInfo: LayoutInfo { width: 150 height: 80 }
	disable: bind (vars.selectedmem_choicebox_item.size() == 0);
	
	onMouseClicked: function(e: MouseEvent):Void
    {
		if(vars.act_selected_members.selectedItem.toString() != "")
		{
			insert vars.act_selected_members.selectedItem.toString() into vars.mem_choicebox_item;
			delete vars.act_selected_members.selectedItem.toString() from vars.selectedmem_choicebox_item;
		}
    }  
}

vars.actscrollbar = ScrollBar
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
function checkMonthIndex(str:String): Integer
{
	var index : Integer;
	if(str == "JAN" or str == "Jan")
	{
		index = 1;
	}
	else if(str == "FEB" or str == "Feb")
	{
		index = 2;
	}
	else if(str == "MAR" or str == "Mar")
	{
		index = 3;
	}
	else if(str == "APR" or str == "Apr")
	{
		index = 4;
	}
	else if(str == "MAY" or str == "May")
	{
		index = 5;
	}
	else if(str == "MAY" or str == "May")
	{
		index = 5;
	}
	else if(str == "JUNE" or str == "Jun")
	{
		index = 6;
	}
	else if(str == "JULY" or str == "Jul")
	{
		index = 7;
	}
	else if(str == "AUG" or str == "Aug")
	{
		index = 8;
	}
	else if(str == "SEP" or str == "Sep")
	{
		index = 9;
	}
	else if(str == "OCT" or str == "Oct")
	{
		index = 10;
	}
	else if(str == "NOV" or str == "Nov")
	{
		index = 11;
	}
	else if(str == "DEC" or str == "Dec")
	{
		index = 12;
	}
	return index;
}

vars.salesper_add_act = Panel
{
    content :
    [
        Panel
        {
			layoutX: 200,
			layoutY: bind -(vars.actscrollbar.value)+100,
			height: 550,
			width: 800
            content:
                [
                    Label
                    {
                        text: "Add Activity";
                        layoutX: 300;
                        layoutY: 40;
                        font:Font.font("ARIAL", FontWeight.BOLD, 20);
                        effect:Glow {level:0.5};
                    }
					
                    Label
                    {
						id: "label";
                        text: "Activity Type";
                        layoutX: 190;
                        layoutY: 100;                        
                    }
					vars.act_type,
                    Label
                    {
						id: "label";
                        text: "Activity Name";
                        layoutX: 190;
                        layoutY: 130;                        
                    }
                    vars.act_name,
					Label
                    {
						id: "label";
                        text: "Activity For";
                        layoutX: 190;
                        layoutY: 160;                        
                    }
					vars.act_for,
					Label
                    {
						id: "label";
                        text: "Activity Date";
                        layoutX: 190;
                        layoutY: 190;                        
                    }
					vars.act_date_y,
					vars.act_date_m,
					vars.act_date_d,
					Label
                    {
						id: "label";
                        text: "Activity Detail";
                        layoutX: 190;
                        layoutY: 250;                        
                    }
					vars.act_detail,
					Label
                    {
						id: "label";
                        text: "Activity Leader";
                        layoutX: 190;
                        layoutY: 300;                        
                    }
					vars.act_leader,
					Label
                    {
						id: "label";
                        text: "Activity Members";
                        layoutX: 190;
                        layoutY: 330;                        
                    }
					vars.act_members,
					Label
                    {
						id: "label";
                        text: "Selected Members";
                        layoutX: 190;
                        layoutY: 420;                        
                    }
					vars.act_selected_members,
					Button
                    {
                        text: "Clear";
                        layoutX: 360;
						layoutY: 510;
                        transforms:
                        [
                            Scale {x: 1.2, y: 1.2}
                        ]
                        action: function()
                        {
							delete vars.selectedmem_choicebox_item;
							get_members_list();
                        }
                    }
                    Button
                    {
                        text: "Add Activity";
                        layoutX: 360;
						layoutY: 540;
                        transforms:
                        [
                            Scale {x: 1.2, y: 1.2}
                        ]
                        action: function()
                        {
							vars.add_activity = true;
							if(vars.act_name.text == "")
							{
								vars.act_name.text = "* Activity Name cannot be empty";
								vars.add_activity = false;
							}
							if(vars.act_for.text == "")
							{
								vars.act_for.text = "* Activity for cannot be empty";
								vars.add_activity = false;
							}
							if(vars.act_detail.text == "")
							{
								vars.act_detail.text = "* Activity detail cannot be empty";
								vars.add_activity = false;
							}
							if((sizeof vars.selectedmem_choicebox_item) == 0)
							{
								Alert.inform("select activity members.");
								vars.add_activity = false;
							}
							
							if(vars.act_date_y.selectedIndex == -1 or vars.act_date_m.selectedIndex == -1 or vars.act_date_d.selectedIndex == -1 or vars.act_date_d.selectedItem == "   ")
							{
								Alert.inform("Select activity date.");
								vars.add_activity = false;
							}
							else
							{
								def date = DateTime{}.instant;
								def year = new SimpleDateFormat("YYYY").format(date);
								def month = new SimpleDateFormat("MMM").format(date);
								def day = new SimpleDateFormat("dd").format(date);
								if(vars.act_date_y.selectedItem == year and checkMonthIndex(vars.act_date_m.selectedItem.toString()) <= checkMonthIndex(month) and Integer.parseInt(vars.act_date_d.selectedItem.toString()) < Integer.parseInt(day))
								{
									vars.add_activity = false;
									Alert.inform("Past dates cannot be entered as Activity Due Date.");
								}
							}
							if(vars.act_type.selectedIndex == -1)
							{
								Alert.inform("Select activity type.");
								vars.add_activity = false;
							}
							admin_vars.rs1 = admin_vars.st.executeQuery("select * from activity_master where act_name='{vars.act_name.text}'");
							if(admin_vars.rs1.next())
							{
								vars.add_activity = false;
								Alert.inform("Activity Name already exists.");
							}							
							if(vars.add_activity == true)
							{
								for(selectedmem_choicebox_value in vars.selectedmem_choicebox_item)
								{
									if(vars.mem_selected_item != "")
									{
										vars.mem_selected_item = "{vars.mem_selected_item}, {selectedmem_choicebox_value.toString()}";
									}
									else
									{
										vars.mem_selected_item = "{selectedmem_choicebox_value.toString()}";
									}
								}
								
								admin_vars.cs = admin_vars.cn.prepareCall("call add_activity_master(?,?,?,?,?,?,?,?,?)");
								admin_vars.cs.setString(1,'{vars.act_type.selectedItem}');
								admin_vars.cs.setString(2,'{vars.act_name.text}');
								admin_vars.cs.setString(3,'{vars.act_for.text}');
								admin_vars.cs.setString(4,'{vars.act_date_d.selectedItem}');
								admin_vars.cs.setString(5,'{vars.act_date_m.selectedItem}');
								admin_vars.cs.setString(6,'{vars.act_date_y.selectedItem}');
								admin_vars.cs.setString(7,'{vars.act_detail.text}');
								admin_vars.cs.setString(8,'{vars.act_leader.text}');
								admin_vars.cs.setString(9,'{vars.mem_selected_item}');
								
								if(admin_vars.cs.executeUpdate() == 0)
								{
									Alert.inform("Activity inserted successfully.");
									add_activity_null();
								}
							}
                        }
                    }					
                ]
        }
    ]
visible:false;
}

// View activities

vars.lv_activity_size = 30 * vars.v_activity_name.size();
vars.viewActivityListView = ListView {
        items: bind [vars.v_activity_name]
		layoutInfo: LayoutInfo{height:bind vars.lv_activity_size width: 750}
		layoutX: 20
		layoutY: 150
		
        cellFactory: function() {
            var listCell: ListCell;           
			
			if(vars.v_activity_name.size() > 5)
            {
                vars.lv_activity_size = 30 * 5;
            }
            else
            {
                vars.lv_activity_size = 30 * vars.v_activity_name.size();
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
                                    text: bind vars.v_activity_type[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_activity_flag or not listCell.selected or (vars.lv_activity_ind != listCell.index)
                                }                                
                            ]
                        }
                         VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_activity_name[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_activity_flag or not listCell.selected or (vars.lv_activity_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_activity_for[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_activity_flag or not listCell.selected or (vars.lv_activity_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_activity_date[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_activity_flag or not listCell.selected or (vars.lv_activity_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 160}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_activity_detail[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_activity_flag or not listCell.selected or (vars.lv_activity_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 70}
                            spacing: 10
                            content: [
                                Button {
                                    vpos: VPos.TOP;
                                    text: "View"
                                    visible: bind not listCell.empty and (not vars.lv_activity_flag or not listCell.selected or (vars.lv_activity_ind != listCell.index))
                                    action: function() {
                                        Alert.inform({vars.v_activity_members[listCell.index]});
                                    }
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
                                    visible: bind not listCell.empty and (not vars.lv_activity_flag or not listCell.selected or (vars.lv_activity_ind != listCell.index))
                                    action: function() {
                                        admin_vars.cs = admin_vars.cn.prepareCall("call delete_activity(?)");
                                        admin_vars.cs.setString(1,'{vars.v_activity_name[listCell.index]}');
                                        admin_vars.cs.executeUpdate();
                                        delete vars.v_activity_name[listCell.index] from vars.v_activity_name;
										vars.v_activity_type[listCell.index] = "";
                                        delete "" from vars.v_activity_type;
										vars.v_activity_for[listCell.index] = "";
                                        delete "" from vars.v_activity_for;
										vars.v_activity_date[listCell.index] = "";
                                        delete "" from vars.v_activity_date;
										vars.v_activity_detail[listCell.index] = "";
                                        delete "" from vars.v_activity_detail;
										vars.v_activity_members[listCell.index] = "";
                                        delete "" from vars.v_activity_members;
										vars.lv_activity_size = 30 * vars.v_activity_name.size();
                                    }
                                }
                            ]
                        }
                        ]
                        }            
            }
        }
        visible:bind not myact;
    };
	
vars.lv_otheractivity_size = 30 * vars.v_otheractivity_name.size();
vars.otherviewActivityListView = ListView {
        items: bind [vars.v_otheractivity_name]
		layoutInfo: LayoutInfo{height:bind vars.lv_otheractivity_size width: 750}
		layoutX: 20
		layoutY: 370
		
        cellFactory: function() {
            var listCell: ListCell;           
			
			if(vars.v_otheractivity_name.size() > 5)
            {
                vars.lv_otheractivity_size = 30 * 5;
            }
            else
            {
                vars.lv_otheractivity_size = 30 * vars.v_otheractivity_name.size();
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
                                    text: bind vars.v_otheractivity_type[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_otheractivity_flag or not listCell.selected or (vars.lv_otheractivity_ind != listCell.index)
                                }                                
                            ]
                        }
                         VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_otheractivity_name[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_otheractivity_flag or not listCell.selected or (vars.lv_otheractivity_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_otheractivity_for[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_otheractivity_flag or not listCell.selected or (vars.lv_otheractivity_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_otheractivity_date[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_otheractivity_flag or not listCell.selected or (vars.lv_otheractivity_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 160}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_otheractivity_detail[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_otheractivity_flag or not listCell.selected or (vars.lv_otheractivity_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 70}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_otheractivity_leader[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_otheractivity_flag or not listCell.selected or (vars.lv_otheractivity_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 70}
                            spacing: 10
                            content: [
                                Button {
                                    vpos: VPos.TOP;
                                    text: "View"
                                    visible: bind not listCell.empty and (not vars.lv_activity_flag or not listCell.selected or (vars.lv_activity_ind != listCell.index))
                                    action: function() {
                                        Alert.inform({vars.v_otheractivity_members[listCell.index]});
                                    }
                                }                  
                            ]
                        }
						
                        ]
                        }            
            }
        }
        visible:bind not otheract;
    };

var myact : Boolean = true;
var otheract : Boolean = true;
vars.view_act_year = ChoiceBox
{
	id: "cb";
	layoutX: 40;
	layoutY: 180;
	items:[1975..2020]	
	visible: bind myact
}
vars.view_act_fyear = ChoiceBox
{
	id: "cb";
	layoutX: 150;
	layoutY: 180;
	items:[1975..2020]	
	visible: bind myact
	disable: bind (vars.view_act_year.selectedIndex == -1)
}
function view_myactivities()
{
	delete vars.v_activity_type;
	delete vars.v_activity_name;
	delete vars.v_activity_for;
	delete vars.v_activity_date;
	delete vars.v_activity_detail;
	delete vars.v_activity_members;
	if(vars.view_act_year.selectedIndex == -1 or vars.view_act_fyear.selectedIndex == -1)
	{
		Alert.inform("Select From and To Year Values.");		
	}
	else if(Integer.parseInt(vars.view_act_year.selectedItem.toString()) > Integer.parseInt(vars.view_act_fyear.selectedItem.toString()))
	{
		Alert.inform("From year must be greater or equal to To year.");
		vars.view_act_fyear.clearSelection();
	}
	else
	{
		admin_vars.rs1 = admin_vars.st.executeQuery("select * from activity_master where act_leader = '{vars.saleper_unm_field.text}'");
		while(admin_vars.rs1.next())
		{
			if(Integer.parseInt({admin_vars.rs1.getString(7).toString()}) >= Integer.parseInt(vars.view_act_year.selectedItem.toString()) and Integer.parseInt({admin_vars.rs1.getString(7).toString()}) <= Integer.parseInt(vars.view_act_fyear.selectedItem.toString()))
			{
				insert {admin_vars.rs1.getString(2).toString()} into vars.v_activity_type;	
				insert {admin_vars.rs1.getString(3).toString()} into vars.v_activity_name;
				insert {admin_vars.rs1.getString(4).toString()} into vars.v_activity_for;
				insert "{admin_vars.rs1.getString(5).toString()}-{admin_vars.rs1.getString(6).toString()}-{admin_vars.rs1.getString(7).toString()}" into vars.v_activity_date;	
				insert {admin_vars.rs1.getString(8).toString()} into vars.v_activity_detail;
				insert {admin_vars.rs1.getString(10).toString()} into vars.v_activity_members;
			}
		}
		vars.lv_activity_size = 30 * vars.v_activity_name.size();
		myact = false;
	}
}
vars.view_act_oyear = ChoiceBox
{
	id: "cb";
	layoutX: 40;
	layoutY: 400;
	items:[1975..2020]	
	visible: bind otheract
}
vars.view_act_ofyear = ChoiceBox
{
	id: "cb";
	layoutX: 150;
	layoutY: 400;
	items:[1975..2020]	
	visible: bind otheract
	disable: bind (vars.view_act_oyear.selectedIndex == -1)
}
function view_otheractivities()
{
	delete vars.v_otheractivity_type;
	delete vars.v_otheractivity_name;
	delete vars.v_otheractivity_for;
	delete vars.v_otheractivity_date;
	delete vars.v_otheractivity_detail;
	delete vars.v_otheractivity_members;
	delete vars.v_otheractivity_leader;
	if(vars.view_act_oyear.selectedIndex == -1 or vars.view_act_ofyear.selectedIndex == -1)
	{
		Alert.inform("Select From and To Year Values.");		
	}
	else if(Integer.parseInt(vars.view_act_oyear.selectedItem.toString()) > Integer.parseInt(vars.view_act_ofyear.selectedItem.toString()))
	{
		Alert.inform("From year must be greater or equal to To year.");
		vars.view_act_ofyear.clearSelection();
	}
	else
	{
		admin_vars.rs1 = admin_vars.st.executeQuery("select * from activity_master where act_leader != '{vars.saleper_unm_field.text}'");
		while(admin_vars.rs1.next())
		{
			if(Integer.parseInt({admin_vars.rs1.getString(7).toString()}) >= Integer.parseInt(vars.view_act_oyear.selectedItem.toString()) and Integer.parseInt({admin_vars.rs1.getString(7).toString()}) <= Integer.parseInt(vars.view_act_ofyear.selectedItem.toString()))
			{
				insert {admin_vars.rs1.getString(2).toString()} into vars.v_otheractivity_type;	
				insert {admin_vars.rs1.getString(3).toString()} into vars.v_otheractivity_name;
				insert {admin_vars.rs1.getString(4).toString()} into vars.v_otheractivity_for;
				insert "{admin_vars.rs1.getString(5).toString()}-{admin_vars.rs1.getString(6).toString()}-{admin_vars.rs1.getString(7).toString()}" into vars.v_otheractivity_date;	
				insert {admin_vars.rs1.getString(8).toString()} into vars.v_otheractivity_detail;
				insert {admin_vars.rs1.getString(9).toString()} into vars.v_otheractivity_leader;
				insert {admin_vars.rs1.getString(10).toString()} into vars.v_otheractivity_members;
			}
		}
		vars.lv_otheractivity_size = 30 * vars.v_otheractivity_name.size();	
		otheract = false;
	}
}
vars.person_view_activities = Panel
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
                    text: "Activities";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
                {
                    text: "My Activities";
					id: "cb";
                    layoutX: 20;
                    layoutY: 80;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
                }
				Label
                {
                    text: "Select Activities";
                    layoutX: 40;
                    layoutY: 110;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
					visible: bind myact
                }
				Label
                {
                    text: "To";
                    layoutX: 40;
                    layoutY: 150;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
					visible: bind myact
                }
				vars.view_act_year,
				Label
                {
                    text: "From";
                    layoutX: 150;
                    layoutY: 150;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
					visible: bind myact
                }
				vars.view_act_fyear,
				Button 
				{
                    text: "View"
					layoutX: 40;
                    layoutY: 210;
                    visible: bind myact
                    action: function() 
					{
						view_myactivities();
                    }
				}             
				Label
				{
					text: "The selected domain does not contain any activities.";
                    layoutX: 220;
                    layoutY: 150;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (vars.viewActivityListView.height == 0) and not myact
				}
				ListView
				{
					layoutInfo: LayoutInfo{width: 750 height: 30}
					layoutX: 20
					layoutY: 100
					visible: bind not (vars.viewActivityListView.height == 0) and not myact
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
											text: "Type"
											visible: bind not (vars.viewActivityListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Name"
											visible: bind not (vars.viewActivityListView.height == 0)
										}
									]
									}					
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "For"
											visible: bind not (vars.viewActivityListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Date"
											visible: bind not (vars.viewActivityListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 160}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Detail"
											visible: bind not (vars.viewActivityListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 70}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Members"
											visible: bind not (vars.viewActivityListView.height == 0)
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
											visible: bind not (vars.viewActivityListView.height == 0)
										}
									]
									}
								]
							}
						}
					}
				}
				vars.viewActivityListView,
				Label
                {
                    text: "Other Activities";
					id: "cb";
                    layoutX: 20;
                    layoutY: 300;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
                }
				Label
                {
                    text: "Select Activities";
                    layoutX: 40;
                    layoutY: 330;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
					visible: bind otheract
                }
				Label
                {
                    text: "To";
                    layoutX: 40;
                    layoutY: 370;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
					visible: bind otheract
                }
				vars.view_act_oyear,
				Label
                {
                    text: "From";
                    layoutX: 150;
                    layoutY: 370;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
					visible: bind otheract
                }
				vars.view_act_ofyear,
				Button 
				{
                    text: "View"
					layoutX: 40;
                    layoutY: 430;
                    visible: bind otheract
                    action: function() 
					{
						view_otheractivities();
                    }
				}
				Label
				{
					text: "The selected domain does not contain any activities.";
                    layoutX: 220;
                    layoutY: 370;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (vars.otherviewActivityListView.height == 0) and not otheract
				}
				ListView
				{
					layoutInfo: LayoutInfo{width: 750 height: 30}
					layoutX: 20
					layoutY: 320
					visible: bind not (vars.otherviewActivityListView.height == 0) and not otheract
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
											text: "Type"
											visible: bind not (vars.otherviewActivityListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Name"
											visible: bind not (vars.otherviewActivityListView.height == 0)
										}
									]
									}					
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "For"
											visible: bind not (vars.otherviewActivityListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Date"
											visible: bind not (vars.otherviewActivityListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 160}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Detail"
											visible: bind not (vars.otherviewActivityListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 70}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Leader"
											visible: bind not (vars.otherviewActivityListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 70}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Members"
											visible: bind not (vars.otherviewActivityListView.height == 0)
										}
									]
									}
								]
							}
						}
					}
				}
				vars.otherviewActivityListView,
			]
		}
	]
	visible: false;
}

// Add Lead

vars.add_lead_type = ChoiceBox
{
	items: ["Telephonic","Face to Face","Letter","SMS","Email"]
	layoutX: 383;
	layoutY: 100;
	scaleX: 1.5;
	layoutInfo: LayoutInfo { width: 100 };
}

vars.add_lead_salesperson = Label
{
	id: "label";
	text: bind vars.saleper_unm_field.text;
	layoutX: 360;
	layoutY: 130;
}

vars.add_lead_Client_rs = admin_vars.st.executeQuery("select CL_FIRST_NAME,CL_LAST_NAME from CLIENT_MASTER");
while(vars.add_lead_Client_rs.next())
{
	insert "{vars.add_lead_Client_rs.getString(1).toString()} {vars.add_lead_Client_rs.getString(2).toString()}" into vars.add_lead_Client_item;							
}
vars.add_lead_client = ChoiceBox
{
	id: "cb";
	layoutX: 383;
	layoutY: 160;
	scaleX: 1.5;                                        
	items: bind [vars.add_lead_Client_item];
	layoutInfo: LayoutInfo { width: 100 };
}

vars.add_lead_date = ChoiceBox
{
	layoutX: 445;
	layoutY: 220;
	items:bind ["   ",admin_vars.dd];
	disable: bind (vars.add_lead_month.selectedIndex == -1);	
}
vars.add_lead_month = ChoiceBox
{
	layoutX: 360;
	layoutY: 220;
	items:["JAN","FEB","MAR","APR","MAY","JUNE","JULY","AUG","SEP","OCT","NOV","DEC"];
	disable: bind (vars.add_lead_year.selectedIndex == -1);
	
	onMouseExited: function(e: MouseEvent): Void
	{
		delete admin_vars.dd;
		if(vars.add_lead_month.selectedItem.toString() == "FEB")
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
		if(vars.add_lead_month.selectedItem.toString() == "JAN" or vars.add_lead_month.selectedItem.toString() == "MAR" or vars.add_lead_month.selectedItem.toString() == "MAY" or vars.add_lead_month.selectedItem.toString() == "JULY" or vars.add_lead_month.selectedItem.toString() == "AUG" or vars.add_lead_month.selectedItem.toString() == "OCT" or vars.add_lead_month.selectedItem.toString() == "DEC")
		{
			for(i in [1..31] )
			{
				insert i.toString() into admin_vars.dd;
			}
		}
		if(vars.add_lead_month.selectedItem.toString() == "APR" or vars.add_lead_month.selectedItem.toString() == "JUNE" or vars.add_lead_month.selectedItem.toString() == "SEP" or vars.add_lead_month.selectedItem.toString() == "NOV")
		{
			for(i in [1..30] )
			{
				insert i.toString() into admin_vars.dd;
			}
		}
	}
}
vars.add_lead_year = ChoiceBox
{
	id: "cb";
	layoutX: 395;
	layoutY: 190;
	scaleX: 1.9;
	items:[admin_vars.yr]
	
	onMouseExited: function(e: MouseEvent): Void
	{
		if(vars.add_lead_year.selectedItem.toString() != "")
		{
			var year: Integer = Integer.parseInt(vars.add_lead_year.selectedItem.toString());
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

vars.add_lead_detail = TextBox
{
	columns: 20;
	layoutX: 360;
	layoutY: 250;
	multiline: true;
	lines: 2;
	onMouseEntered: function(e: MouseEvent):Void
    {
		vars.add_lead_detail.columns = 30;
		vars.add_lead_detail.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		vars.add_lead_detail.columns = 20;
		vars.add_lead_detail.translateX = 1;
    }
}

vars.salesper_add_lead = Panel
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
                        text: "Add Lead";
                        layoutX: 300;
                        layoutY: 40;
                        font:Font.font("ARIAL", FontWeight.BOLD, 20);
                        effect:Glow {level:0.5};
                    }
					
                    Label
                    {
						id: "label";
                        text: "Lead Type";
                        layoutX: 190;
                        layoutY: 100;                        
                    }
					vars.add_lead_type,
                    Label
                    {
						id: "label";
                        text: "Person";
                        layoutX: 190;
                        layoutY: 130;                        
                    }
                    vars.add_lead_salesperson,
					Label
                    {
						id: "label";
                        text: "Client";
                        layoutX: 190;
                        layoutY: 160;                        
                    }
					vars.add_lead_client,
					Label
                    {
						id: "label";
                        text: "Lead Due Date";
                        layoutX: 190;
                        layoutY: 190;                        
                    }
					vars.add_lead_date,
					vars.add_lead_month,
					vars.add_lead_year,
					Label
                    {
						id: "label";
                        text: "Lead Detail";
                        layoutX: 190;
                        layoutY: 250;                        
                    }
					vars.add_lead_detail,
                    Button
                    {
                        text: "Add Lead";
                        layoutX: 360;
						layoutY: 300;
                        transforms:
                        [
                            Scale {x: 1.2, y: 1.2}
                        ]
                        action: function()
                        {
							vars.add_lead = true;
							if(vars.add_lead_type.selectedIndex == -1)
							{
								Alert.inform("select lead type.");
								vars.add_lead = false;
							}
							if(vars.add_lead_client.selectedIndex == -1)
							{
								Alert.inform("select client.");
								vars.add_lead = false;
							}
							if(vars.add_lead_date.selectedIndex == -1 or vars.add_lead_month.selectedIndex == -1 or vars.add_lead_year.selectedIndex == -1 or vars.add_lead_date.selectedItem == "   " or vars.add_lead_date.selectedItem == "")
							{
								Alert.inform("select lead due date.");
								vars.add_lead = false;
							}
							else
							{
								def date = DateTime{}.instant;
								def year = new SimpleDateFormat("YYYY").format(date);
								def month = new SimpleDateFormat("MMM").format(date);
								def day = new SimpleDateFormat("dd").format(date);
								if(vars.add_lead_year.selectedItem == year and checkMonthIndex(vars.add_lead_month.selectedItem.toString()) <= checkMonthIndex(month) and Integer.parseInt(vars.add_lead_date.selectedItem.toString()) < Integer.parseInt(day))
								{
									vars.add_lead = false;
									Alert.inform("Past dates cannot be entered as Lead Due Date.");
								}
							}
							if(vars.add_lead_detail.text == "")
							{
								vars.add_lead_detail.text = "* Enter lead detail.";
								vars.add_lead = false;
							}							
							if(vars.add_lead == true)
							{
								admin_vars.cs = admin_vars.cn.prepareCall("call add_lead_master(?,?,?,?,?,?,?)");
								admin_vars.cs.setString(1,'{vars.add_lead_type.selectedItem}');
								admin_vars.cs.setString(2,'{vars.add_lead_salesperson.text}');
								admin_vars.cs.setString(3,'{vars.add_lead_client.selectedItem}');
								admin_vars.cs.setString(4,'{vars.add_lead_date.selectedItem}');
								admin_vars.cs.setString(5,'{vars.add_lead_month.selectedItem}');
								admin_vars.cs.setString(6,'{vars.add_lead_year.selectedItem}');
								admin_vars.cs.setString(7,'{vars.add_lead_detail.text}');
									
								if(admin_vars.cs.executeUpdate() == 0)
								{
									Alert.inform("Lead inserted successfully.");
									add_lead_null();
								}
							}
                        }
                    }					
                ]
        }
    ]
visible:false;
}

// View lead

vars.lv_lead_size = 30 * vars.v_lead_client.size();
vars.viewLeadListView = ListView {
        items: bind [vars.v_lead_client]
		layoutInfo: LayoutInfo{height:bind vars.lv_lead_size width: 750}
		layoutX: 20
		layoutY: 150
        cellFactory: function() {
            var listCell: ListCell;           
			
			if(vars.v_lead_client.size() > 5)
            {
                vars.lv_lead_size = 30 * 5;
            }
            else
            {
                vars.lv_lead_size = 30 * vars.v_lead_client.size();
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
                                    text: bind vars.v_lead_type[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_lead_flag or not listCell.selected or (vars.lv_lead_ind != listCell.index)
                                }                                
                            ]
                        }
                         VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_lead_client[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_lead_flag or not listCell.selected or (vars.lv_lead_ind != listCell.index)
                                }                  
                            ]
                        }
						
						VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_lead_date[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_lead_flag or not listCell.selected or (vars.lv_lead_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 160}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_lead_detail[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_lead_flag or not listCell.selected or (vars.lv_lead_ind != listCell.index)
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
                                    visible: bind not listCell.empty and (not vars.lv_lead_flag or not listCell.selected or (vars.lv_lead_ind != listCell.index))
                                    action: function() {
                                        admin_vars.cs = admin_vars.cn.prepareCall("call delete_lead(?,?,?)");
                                        admin_vars.cs.setString(1,'{vars.v_lead_type[listCell.index]}');
										admin_vars.cs.setString(2,'{vars.saleper_unm_field.text}');
										admin_vars.cs.setString(3,'{vars.v_lead_client[listCell.index]}');
                                        admin_vars.cs.executeUpdate();
										vars.v_lead_type[listCell.index] = "";
                                        delete "" from vars.v_lead_type;
										vars.v_lead_client[listCell.index] = "";
										delete ""  from vars.v_lead_client;
										vars.v_lead_date[listCell.index] = "";
										delete "" from vars.v_lead_date;
										vars.v_lead_detail[listCell.index] = "";
										delete "" from vars.v_lead_detail;
										vars.lv_lead_size = 30 * vars.v_lead_client.size();
                                    }
                                }
                            ]
                        }
                        ]
                        }            
            }
        }
        visible:bind not mylead;
    };
	
vars.lv_otherlead_size = 30 * vars.v_otherlead_client.size();
vars.otherviewLeadListView = ListView {
        items: bind [vars.v_otherlead_client]
		layoutInfo: LayoutInfo{height:bind vars.lv_otherlead_size width: 750}
		layoutX: 20
		layoutY: 370
        cellFactory: function() {
            var listCell: ListCell;           
			
			if(vars.v_otherlead_client.size() > 5)
            {
                vars.lv_otherlead_size = 30 * 5;
            }
            else
            {
                vars.lv_otherlead_size = 30 * vars.v_otherlead_client.size();
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
                                    text: bind vars.v_otherlead_type[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_otherlead_flag or not listCell.selected or (vars.lv_otherlead_ind != listCell.index)
                                }                                
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_otherlead_person[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_otherlead_flag or not listCell.selected or (vars.lv_otherlead_ind != listCell.index)
                                }                  
                            ]
                        }
                         VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_otherlead_client[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_otherlead_flag or not listCell.selected or (vars.lv_otherlead_ind != listCell.index)
                                }                  
                            ]
                        }
						
						VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_otherlead_date[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_otherlead_flag or not listCell.selected or (vars.lv_otherlead_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.v_otherlead_detail[listCell.index]
                                    visible: bind not listCell.empty and not vars.lv_otherlead_flag or not listCell.selected or (vars.lv_otherlead_ind != listCell.index)
                                }                  
                            ]
                        }
                        ]
                        }            
            }
        }
        visible:bind not otherlead;
    };
	
var mylead : Boolean = true;
var otherlead : Boolean = true;
vars.view_lead_year = ChoiceBox
{
	id: "cb";
	layoutX: 40;
	layoutY: 180;
	items:[1975..2020]	
	visible: bind mylead
}
vars.view_lead_fyear = ChoiceBox
{
	id: "cb";
	layoutX: 150;
	layoutY: 180;
	items:[1975..2020]	
	visible: bind mylead
	disable: bind (vars.view_lead_year.selectedIndex == -1)
}
function view_myleads()
{
	delete vars.v_lead_type;
	delete vars.v_lead_client;
	delete vars.v_lead_date;
	delete vars.v_lead_detail;
	if(vars.view_lead_year.selectedIndex == -1 or vars.view_lead_fyear.selectedIndex == -1)
	{
		Alert.inform("Select From and To Year Values.");		
	}
	else if(Integer.parseInt(vars.view_lead_year.selectedItem.toString()) > Integer.parseInt(vars.view_lead_fyear.selectedItem.toString()))
	{
		Alert.inform("From year must be greater or equal to To year.");
		vars.view_lead_fyear.clearSelection();
	}
	else
	{
		admin_vars.rs1 = admin_vars.st.executeQuery("select * from lead_master where lead_salesman = '{vars.saleper_unm_field.text}'");
		while(admin_vars.rs1.next())
		{
			if(Integer.parseInt({admin_vars.rs1.getString(7).toString()}) >= Integer.parseInt(vars.view_lead_year.selectedItem.toString()) and Integer.parseInt({admin_vars.rs1.getString(7).toString()}) <= Integer.parseInt(vars.view_lead_fyear.selectedItem.toString()))
			{
				insert {admin_vars.rs1.getString(2).toString()} into vars.v_lead_type;	
				insert {admin_vars.rs1.getString(4).toString()} into vars.v_lead_client;
				insert "{admin_vars.rs1.getString(5).toString()}-{admin_vars.rs1.getString(6).toString()}-{admin_vars.rs1.getString(7).toString()}" into vars.v_lead_date;	
				insert {admin_vars.rs1.getString(8).toString()} into vars.v_lead_detail;
			}
		}
		vars.lv_lead_size = 30 * vars.v_lead_client.size();
		mylead = false;
	}
}
vars.view_lead_oyear = ChoiceBox
{
	id: "cb";
	layoutX: 40;
	layoutY: 400;
	items:[1975..2020]	
	visible: bind otherlead
}
vars.view_lead_ofyear = ChoiceBox
{
	id: "cb";
	layoutX: 150;
	layoutY: 400;
	items:[1975..2020]	
	visible: bind otherlead
	disable: bind (vars.view_lead_oyear.selectedIndex == -1)
}
function view_otherleads()
{
	delete vars.v_otherlead_type;
	delete vars.v_otherlead_person;
	delete vars.v_otherlead_date;
	delete vars.v_otherlead_detail;
	delete vars.v_otherlead_client;
	if(vars.view_lead_oyear.selectedIndex == -1 or vars.view_lead_ofyear.selectedIndex == -1)
	{
		Alert.inform("Select From and To Year Values.");		
	}
	else if(Integer.parseInt(vars.view_lead_oyear.selectedItem.toString()) > Integer.parseInt(vars.view_lead_ofyear.selectedItem.toString()))
	{
		Alert.inform("From year must be greater or equal to To year.");
		vars.view_lead_fyear.clearSelection();
	}
	else
	{
		admin_vars.rs1 = admin_vars.st.executeQuery("select * from lead_master where lead_salesman != '{vars.saleper_unm_field.text}'");
		while(admin_vars.rs1.next())
		{
			if(Integer.parseInt({admin_vars.rs1.getString(7).toString()}) >= Integer.parseInt(vars.view_lead_oyear.selectedItem.toString()) and Integer.parseInt({admin_vars.rs1.getString(7).toString()}) <= Integer.parseInt(vars.view_lead_ofyear.selectedItem.toString()))
			{
				insert {admin_vars.rs1.getString(2).toString()} into vars.v_otherlead_type;	
				insert {admin_vars.rs1.getString(3).toString()} into vars.v_otherlead_person;
				insert "{admin_vars.rs1.getString(5).toString()}-{admin_vars.rs1.getString(6).toString()}-{admin_vars.rs1.getString(7).toString()}" into vars.v_otherlead_date;	
				insert {admin_vars.rs1.getString(8).toString()} into vars.v_otherlead_detail;
				insert {admin_vars.rs1.getString(4).toString()} into vars.v_otherlead_client;
			}
		}
		vars.lv_otherlead_size = 30 * vars.v_otherlead_person.size();	
		otherlead = false;
	}
}	
vars.person_view_leads = Panel
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
                    text: "Leads";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
                {
                    text: "My Leads";
					id: "cb";
                    layoutX: 20;
                    layoutY: 80;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
                }
				Label
                {
                    text: "Select Leads";
                    layoutX: 40;
                    layoutY: 110;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
					visible: bind mylead
                }
				Label
                {
                    text: "To";
                    layoutX: 40;
                    layoutY: 150;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
					visible: bind mylead
                }
				vars.view_lead_year,
				Label
                {
                    text: "From";
                    layoutX: 150;
                    layoutY: 150;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
					visible: bind mylead
                }
				vars.view_lead_fyear,
				Button 
				{
                    text: "View"
					layoutX: 40;
                    layoutY: 210;
                    visible: bind mylead
                    action: function() 
					{
						view_myleads();
                    }
				}
				Label
				{
					text: "The selected domain does not contain any leads.";
                    layoutX: 220;
                    layoutY: 150;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (vars.viewLeadListView.height == 0) and not mylead
				}
				ListView
				{
					layoutInfo: LayoutInfo{width: 750 height: 30}
					layoutX: 20
					layoutY: 100
					visible: bind not (vars.viewLeadListView.height == 0) and not mylead
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
											text: "Type"
											visible: bind not (vars.viewLeadListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Client"
											visible: bind not (vars.viewLeadListView.height == 0)
										}
									]
									}					
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Date"
											visible: bind not (vars.viewLeadListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 160}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Detail"
											visible: bind not (vars.viewLeadListView.height == 0)
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
											visible: bind not (vars.viewLeadListView.height == 0)
										}
									]
									}
								]
							}
						}
					}
				}
				vars.viewLeadListView,
				Label
                {
                    text: "Other Leads";
                    id: "cb";
					layoutX: 20;
                    layoutY: 300;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
                }
				Label
                {
                    text: "Select Leads";
                    layoutX: 40;
                    layoutY: 330;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
					visible: bind otherlead
                }
				Label
                {
                    text: "To";
                    layoutX: 40;
                    layoutY: 370;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
					visible: bind otherlead
                }
				vars.view_lead_oyear,
				Label
                {
                    text: "From";
                    layoutX: 150;
                    layoutY: 370;
                    font:Font.font("ARIAL", FontWeight.BOLD, 16);
					visible: bind otherlead
                }
				vars.view_lead_ofyear,
				Button 
				{
                    text: "View"
					layoutX: 40;
                    layoutY: 430;
                    visible: bind otherlead
                    action: function() 
					{
						view_otherleads();
                    }
				}
				
				Label
				{
					text: "The selected domain does not contain any leads.";
                    layoutX: 220;
                    layoutY: 370;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (vars.otherviewLeadListView.height == 0) and not otherlead
				}
				ListView
				{
					layoutInfo: LayoutInfo{width: 750 height: 30}
					layoutX: 20
					layoutY: 320
					visible: bind not (vars.otherviewLeadListView.height == 0) and not otherlead
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
											text: "Type"
											visible: bind not (vars.otherviewLeadListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Person Name"
											visible: bind not (vars.otherviewLeadListView.height == 0)
										}
									]
									}					
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Client"
											visible: bind not (vars.otherviewLeadListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											id: "lbl2"
											text: "Date"
											visible: bind not (vars.otherviewLeadListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [          
										Label {
											id: "lbl2"
											text: "Detail"
											visible: bind not (vars.otherviewLeadListView.height == 0)
										}
									]
									}
								]
							}
						}
					}
				}
				vars.otherviewLeadListView,
			]
		}
	]
	visible: false;
}

//new sell
vars.add_sell_client = ChoiceBox
{
	id: "cb";
	layoutX: 370;
	layoutY: 100;
	scaleX: 1.3; 
	layoutInfo: LayoutInfo { width: 100 }	
	items: bind [vars.add_sell_Client_item];
}

vars.add_sell_product = ChoiceBox
{
	id: "cb";
	layoutX: 370;
	layoutY: 130;
	scaleX: 1.3; 
	layoutInfo: LayoutInfo { width: 100 }
	items: bind [vars.add_sell_product_item];
	onMouseExited: function(e: MouseEvent): Void
	{
		vars.add_sell_product_rs = admin_vars.st.executeQuery("select QUANTITY from PRODUCT_MASTER where NAME='{vars.add_sell_product.selectedItem}'");
		while(vars.add_sell_product_rs.next())
		{
			vars.add_sell_totalquantity = vars.add_sell_product_rs.getInt(1);							
		}
	}
}


vars.add_sell_qty = TextBox
{
	columns: 15;
	layoutX: 360;
	layoutY: 160;
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(vars.add_sell == false)
		{
			vars.add_sell_qty.text = "";
		}
	}
}

vars.add_sell_totalqty = Label
{
	id: "label";
	text: bind vars.add_sell_totalquantity.toString();
	layoutX: 490;
	layoutY: 160;
}

vars.salesper_new_sell = Panel
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
                        text: "New Sell";
                        layoutX: 300;
                        layoutY: 40;
                        font:Font.font("ARIAL", FontWeight.BOLD, 20);
                        effect:Glow {level:0.5};
                    }
					
                    Label
                    {
						id: "label";
                        text: "Client";
                        layoutX: 190;
                        layoutY: 100;                        
                    }
					vars.add_sell_client,
					Label
                    {
						id: "label";
                        text: "Product";
                        layoutX: 190;
                        layoutY: 130;                        
                    }
					vars.add_sell_product,
                    Label
                    {
						id: "label";
                        text: "Quantity";
                        layoutX: 190;
                        layoutY: 160;                        
                    }
                    vars.add_sell_qty,
					Label
                    {
						id: "label";
                        text: "/";
                        layoutX: 480;
                        layoutY: 160;                        
                    }
					vars.add_sell_totalqty,
                    Button
                    {
                        text: "Add Sell";
                        layoutX: 360;
						layoutY: 190;
                        transforms:
                        [
                            Scale {x: 1.2, y: 1.2}
                        ]
                        action: function()
                        {
							vars.add_sell = true;
							if(vars.add_sell_client.selectedIndex == -1)
							{
								Alert.inform("Select client.");
								vars.add_sell = false;
							}
							if(vars.add_sell_product.selectedIndex == -1)
							{
								Alert.inform("Select product.");
								vars.add_sell = false;
							}
							if(vars.add_sell_qty.text == "")
							{
								vars.add_sell_qty.text = "* Enter quantity.";
								vars.add_sell = false;
							}
							else//new 19-04
							{
								matcher = vars.sellpattern.matcher(vars.add_sell_qty.text);
								if(matcher.matches())
								{
									if(Integer.parseInt({vars.add_sell_qty.text}) > vars.add_sell_totalquantity)
									{
										vars.add_sell_qty.text = "* Qty not more than stock.";
										vars.add_sell = false;
									}
								}
								else
								{
									vars.add_sell_qty.text = "* Qty should be in digits.";
									vars.add_sell = false;
								}
							}
							if(vars.add_sell_totalquantity == 0)
							{
								Alert.inform("Product unavilable or out of stock.");
								vars.add_sell = false;
							}							
							if(vars.add_sell == true)
							{
								def date = DateTime{}.instant;

								def year = new SimpleDateFormat("YYYY").format(date);
								def month = new SimpleDateFormat("MMM").format(date);
								def day = new SimpleDateFormat("dd").format(date);
								
								admin_vars.cs = admin_vars.cn.prepareCall("call add_stock_master(?,?,?,?,?,?,?)");
								admin_vars.cs.setString(1,'{vars.saleper_unm_field.text}');
								admin_vars.cs.setString(2,'{vars.add_sell_client.selectedItem}');
								admin_vars.cs.setString(3,'{vars.add_sell_product.selectedItem}');
								admin_vars.cs.setInt(4,Integer.parseInt({vars.add_sell_qty.text}));
								admin_vars.cs.setString(5,'{day}');
								admin_vars.cs.setString(6,'{month}');
								admin_vars.cs.setString(7,'{year}');
								if(admin_vars.cs.executeUpdate() == 0)
								{
									vars.add_sell_product_rs = admin_vars.st.executeQuery("select QUANTITY from PRODUCT_MASTER where NAME='{vars.add_sell_product.selectedItem}'");
									if(vars.add_sell_product_rs.next())
									{
										admin_vars.st.executeUpdate("update PRODUCT_MASTER set QUANTITY = {vars.add_sell_product_rs.getInt(1) - Integer.parseInt({vars.add_sell_qty.text})} where NAME='{vars.add_sell_product.selectedItem.toString()}'");
									}
									
									vars.add_sell_product_rs = admin_vars.st.executeQuery("select TARGET_STATUS from SALESMAN_MASTER where USERNAME='{vars.saleper_unm_field.text}'");
									if(vars.add_sell_product_rs.next())
									{
										admin_vars.st.executeUpdate("update SALESMAN_MASTER set TARGET_STATUS = {vars.add_sell_product_rs.getInt(1) + Integer.parseInt({vars.add_sell_qty.text})} where USERNAME='{vars.saleper_unm_field.text}'");
									}
									else
									{
										admin_vars.st.executeUpdate("update SALESMAN_MASTER set TARGET_STATUS = {Integer.parseInt({vars.add_sell_qty.text})} where USERNAME='{vars.saleper_unm_field.text}'");
									}
									Alert.inform("Sell inserted successfully.");
									add_sell_null();
								}
							}
                        }
                    }					
                ]
        }
    ]
visible:false;
}

//View Target

vars.viewMyTargetListView = ListView {
        items: bind [vars.myTarget]
		layoutInfo: LayoutInfo{height:bind vars.lv_myTar_size width: 300}
		layoutX: 250
		layoutY: 150
		
        cellFactory: function() {
            var listCell: ListCell;           
			
            listCell = ListCell {
                node : HBox {
					content: [
                         VBox {
							layoutInfo: LayoutInfo{width: 150}
			                spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind vars.myTarget[listCell.index]
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
                                    text: bind vars.myDueDate[listCell.index]
                                    visible: not listCell.empty
                                }
                            ]
                        }
                    ]
                }					
            }
        }
        visible:true;
    };
	
vars.salesperson_view_target = Panel
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
                    text: "Your Current Target";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
				{
					text: "You are not given any target yet.";
                    layoutX: 270;
                    layoutY: 150;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (vars.viewMyTargetListView.height == 0)
				}
				ListView
				{
					layoutInfo: LayoutInfo{width: 300 height: 30}
					layoutX: 250
					layoutY: 100
					visible: bind not (vars.viewMyTargetListView.height == 0)
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
											text: "TargetValue"
											font:Font.font("CALIBRI", FontWeight.BOLD, 20);
											visible: bind not (vars.viewMyTargetListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											text: "Due Date"
											font:Font.font("CALIBRI", FontWeight.BOLD, 20);
											visible: bind not (vars.viewMyTargetListView.height == 0)
										}
									]
									}					
								]
							}
						}
					}
				}
				vars.viewMyTargetListView,
			]
		}
	]
	visible: false;
}


// Edit Profile
vars.sp_fnm = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 300;
	layoutY: 100;
	onMouseEntered: function(e: MouseEvent):Void
    {
		vars.sp_fnm.columns = 30;
		vars.sp_fnm.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		vars.sp_fnm.columns = 20;
		vars.sp_fnm.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(vars.sp_error == false)
		{
			vars.sp_fnm.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			vars.sp_mnm.requestFocus();
			vars.sp_fnm.text = vars.sp_fnm.text.trim();
		}
	}
}
vars.sp_mnm = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 300;
	layoutY: 130;
	onMouseEntered: function(e: MouseEvent):Void
    {
		vars.sp_mnm.columns = 30;
		vars.sp_mnm.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		vars.sp_mnm.columns = 20;
		vars.sp_mnm.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(vars.sp_error == false)
		{
			vars.sp_mnm.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			vars.sp_lnm.requestFocus();
			vars.sp_mnm.text = vars.sp_mnm.text.trim();
		}
	}
}
vars.sp_lnm = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 300;
	layoutY: 160;
	onMouseEntered: function(e: MouseEvent):Void
    {
		vars.sp_lnm.columns = 30;
		vars.sp_lnm.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		vars.sp_lnm.columns = 20;
		vars.sp_lnm.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(vars.sp_error == false)
		{
			vars.sp_lnm.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			vars.sp_byear.requestFocus();
			vars.sp_lnm.text = vars.sp_lnm.text.trim();
		}
	}
}
vars.sp_bdate = ChoiceBox
{
	layoutX: 385
	layoutY: 220
	items: bind ["  ",admin_vars.dd]
	disable: bind (vars.sp_bmon.selectedIndex == -1)
}
vars.sp_bmon = ChoiceBox
{
	layoutX: 300
	layoutY: 220
	items: ["JAN","FEB","MAR","APR","MAY","JUNE","JULY","AUG","SEP","OCT","NOV","DEC"]
	disable: bind (vars.sp_byear.selectedIndex == -1)
	
	onMouseExited: function(e: MouseEvent): Void
	{
		delete admin_vars.dd;
		if(vars.sp_bmon.selectedItem.toString() == "FEB")
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
		if(vars.sp_bmon.selectedItem.toString() == "JAN" or vars.sp_bmon.selectedItem.toString() == "MAR" or vars.sp_bmon.selectedItem.toString() == "MAY" or vars.sp_bmon.selectedItem.toString() == "JULY" or vars.sp_bmon.selectedItem.toString() == "AUG" or vars.sp_bmon.selectedItem.toString() == "OCT" or vars.sp_bmon.selectedItem.toString() == "DEC")
		{
			for(i in [1..31] )
			{
				insert i.toString() into admin_vars.dd;
			}
		}
		if(vars.sp_bmon.toString() == "APR" or vars.sp_bmon.selectedItem.toString() == "JUNE" or vars.sp_bmon.selectedItem.toString() == "SEP" or vars.sp_bmon.selectedItem.toString() == "NOV")
		{
			for(i in [1..30] )
			{
				insert i.toString() into admin_vars.dd;
			}
		}
	}
}
vars.sp_byear = ChoiceBox
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
vars.sp_phno = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 300;
	layoutY: 250;
	onMouseEntered: function(e: MouseEvent):Void
    {
		vars.sp_phno.columns = 30;
		vars.sp_phno.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		vars.sp_phno.columns = 20;
		vars.sp_phno.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(vars.sp_error == false)
		{
			vars.sp_phno.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			vars.sp_email.requestFocus();
			vars.sp_phno.text = vars.sp_phno.text.trim();
		}
	}
}
vars.sp_email = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 300;
	layoutY: 280;
	onMouseEntered: function(e: MouseEvent):Void
    {
		vars.sp_email.columns = 30;
		vars.sp_email.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		vars.sp_email.columns = 20;
		vars.sp_email.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(vars.sp_error == false)
		{
			vars.sp_email.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			vars.sp_add.requestFocus();
			vars.sp_email.text = vars.sp_email.text.trim();
		}
	}
}
vars.sp_add = TextBox
{
	columns: 20;
	multiline: true;
	lines: 3;
	layoutX: 300;
	layoutY: 310;
	onMouseEntered: function(e: MouseEvent):Void
    {
		vars.sp_add.columns = 30;
		vars.sp_add.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		vars.sp_add.columns = 20;
		vars.sp_add.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(vars.sp_error == false)
		{
			vars.sp_add.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			vars.sp_pic.requestFocus();
			vars.sp_add.text = vars.sp_add.text.trim();
		}
	}
}
vars.sp_pic = ImageView {    
    x: 550
	y: 100
	fitWidth: 200
	fitHeight: 150
}
vars.sp_picbtn = Button {
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
				vars.sp_piclbl.text = fileobj.getName();
				admin_vars.image = ImageIO.read(fileobj);
			}
			else
			{
				Alert.inform("Select JPEG files.");
			}							
		}
	}
}
vars.sp_piclbl = Label
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

vars.sp_edit_profile = Panel
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
				vars.sp_fnm,
				Label
				{
					id: "label";
					text: "Middle Name";
					layoutX: 190;
					layoutY: 130;
				}
				vars.sp_mnm,
				Label
				{
					id: "label";
					text: "Last Name";
					layoutX: 190;
					layoutY: 160;
				}
				vars.sp_lnm,
				Label
				{
					id: "label";
					text: "Birthdate";
					layoutX: 190;
					layoutY: 190;
				}
				vars.sp_bdate,vars.sp_bmon,vars.sp_byear,
				Label
				{
					id: "label";
					text: "Phone No.";
					layoutX: 190;
					layoutY: 250;
				}
				vars.sp_phno,
				Label
				{
					id: "label";
					text: "Email";
					layoutX: 190;
					layoutY: 280;
				}
				vars.sp_email,
				Label
				{
					id: "label";
					text: "Address";
					layoutX: 190;
					layoutY: 310;
				}
				vars.sp_add,
				vars.sp_pic,
				vars.sp_picbtn,
				vars.sp_piclbl,
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
							vars.sp_error = true;
							if(vars.sp_fnm.text == "")
							{
								vars.sp_fnm.text = "* First Name cannot be empty";
								vars.sp_error = false;
							}
							if(vars.sp_mnm.text == "")
							{
								vars.sp_mnm.text = "* Middle Name cannot be empty";
								vars.sp_error = false;
							}
							if(vars.sp_lnm.text == "")
							{
								vars.sp_lnm.text = "* Last Name cannot be empty";
								vars.sp_error = false;
							}
							if(vars.sp_bdate.selectedIndex == -1 or vars.sp_bmon.selectedIndex == -1 or vars.sp_byear.selectedIndex == -1 or vars.sp_bdate.selectedItem == "  ")
							{
								Alert.inform("Select Birthdate.");
								vars.sp_error = false;
							}							
							if(vars.sp_phno.text.length() < 10 or vars.sp_phno.text.length() > 10)
							{
								vars.sp_phno.text = "* Phone no must be 10 digits long.";
								vars.sp_error = false;
							}
							else
							{
								matcher = admin_vars.phonepattern.matcher(vars.sp_phno.text);
								if(not matcher.matches())
								{
									vars.sp_phno.text = "* Invalid Phone no.";
									vars.sp_error = false;
								}
							}							
							if(vars.sp_email.text == "")
							{
								vars.sp_email.text = "* Email cannot be empty";
								vars.sp_error = false;								
							}							
							else 
							{
								matcher = admin_vars.pattern.matcher(vars.sp_email.text);
								if(not matcher.matches())
								{
									vars.sp_email.text = "* Email is not valid";
									vars.sp_error = false;
								}
							}
							if(vars.sp_add.text == "")
							{
								vars.sp_add.text = "* Address cannot be empty";
								vars.sp_error = false;
							}
							if(vars.sp_piclbl.text == "No File Selected")
							{
								Alert.inform("Select JPEG File.");
								vars.sp_error = false;
							}
							if(vars.sp_error == true)
							{
								admin_vars.cs = admin_vars.cn.prepareCall("call update_person(?,?,?,?,?,?,?,?,?,?,?)");
								admin_vars.cs.setString(1,'{vars.saleper_unm_field.text}');
								admin_vars.cs.setString(2,'{vars.sp_fnm.text}');
								admin_vars.cs.setString(3,'{vars.sp_mnm.text}');
								admin_vars.cs.setString(4,'{vars.sp_lnm.text}');
								admin_vars.cs.setString(5,'{vars.sp_bdate.selectedItem}');
								admin_vars.cs.setString(6,'{vars.sp_bmon.selectedItem}');
								admin_vars.cs.setString(7,'{vars.sp_byear.selectedItem}');
								admin_vars.cs.setString(8,'{vars.sp_phno.text}');
								admin_vars.cs.setString(9,'{vars.sp_email.text}');
								admin_vars.cs.setString(10,'{vars.sp_add.text}');
								admin_vars.cs.setString(11,"{vars.saleper_unm_field.text}.jpg");
								
								if(admin_vars.cs.executeUpdate() == 0)
								{
									var targetFile: File;
									targetFile = new File("userpic/{vars.saleper_unm_field.text}.jpg");
									ImageIO.write(admin_vars.image, "jpg", targetFile);
									
									Alert.inform("Person Data updated successfully.");									
									vars.sp_pic.image = Image{url: "{__DIR__}/userpic/{vars.saleper_unm_field.text}.jpg"};
									vars.sp_byear.clearSelection();
									vars.sp_bmon.clearSelection();
									vars.sp_bdate.clearSelection();
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
            salesperson,
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

// Sales Person Scene

var salesperson_scene = Scene {
		fill: Color.LAVENDERBLUSH;				
		stylesheets: ["{__DIR__}sams.css"]
        content: [
            vars.salesper_add_act,vars.actscrollbar,vars.salesper_add_lead,vars.salesper_new_sell,vars.sp_edit_profile,vars.salesperson_view_target,
			vars.person_view_activities,vars.person_view_leads,vars.per_afterlogin,
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
            vars.salesperson_side_panel,
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