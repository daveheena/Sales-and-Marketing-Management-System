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
import admin_variables.*;
import javafx.date.DateTime;
import java.text.SimpleDateFormat;

var admin_vars = new admin_variables();
var filechooser = new JFileChooser();

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

admin_vars.rs1 = admin_vars.st.executeQuery("select Name,Description from DEPT_MASTER");
while(admin_vars.rs1.next())
{
	insert admin_vars.rs1.getString(1).toString() into admin_vars.dept_choicebox_item;							
	insert admin_vars.rs1.getString(2).toString() into admin_vars.description;	
}

//Side Panels

admin_vars.main_side_panel = Panel
{
	content :
	[
		Panel
		{
			content:
			[
				Hyperlink
				{
						text: "Administrator"
						layoutX: 30;
						layoutY: 120;						
						action: function()
						{
							admin_vars.admin.visible = true; 
							img1.visible = false;
							img2.visible = false;
							admin_vars.msg = "";
							admin_vars.admin_unm_field.text = "";
							admin_vars.admin_pass_field.text = ""
						}			
				}
			]
		}
	]
	visible:true;
}

function admin_sidepanel_visiblefalse()
{
	admin_vars.admin_add_designation.visible = false;
	admin_vars.admin_add_department.visible = false;
	admin_vars.admin_add_manager.visible = false;
	admin_vars.admin_view_department.visible = false;							
	admin_vars.scrollbar.visible = false;
	admin_vars.admin_addProduct.visible = false;
	admin_vars.admin_afterlogin.visible = false;
	admin_vars.admin_view_designation.visible = false;
	admin_vars.admin_view_product.visible = false;
	admin_vars.admin_view_manager.visible = false;
}
function admin_addmanager_valuenull()
{
	admin_vars.admin_addManager_fnm_field.text = "";
	admin_vars.admin_addManager_mnm_field.text = "";
	admin_vars.admin_addManager_lnm_field.text = "";
	admin_vars.admin_addManager_unm_field.text = "";
	admin_vars.admin_addManager_pass_field.text = "";
	admin_vars.admin_addManager_phoneno_field.text = "";
	admin_vars.admin_addManager_email_field.text = "";
	admin_vars.admin_addManager_address_field.text = "";		
	admin_vars.addsalesmanagerbirthmonth.clearSelection();
	admin_vars.addsalesmanagerbirthyear.clearSelection();
	admin_vars.addsalesmanagerbirthdate.clearSelection();
	admin_vars.admin_addManager_deptchoicebox.clearSelection();
	admin_vars.selectedfilelabel.text = "No File Selected.";
}
admin_vars.admin_side_panel = Panel
{
	content : 
	[
		Panel
		{
			content:
			[
				Hyperlink
				{
						text: "Add Department"
						layoutX: 30;
						layoutY: 120;
						action: function()
						{
							admin_sidepanel_visiblefalse();
							admin_vars.admin_addDept_name_field.text = "";
							admin_vars.admin_addDept_desc_field.text = "";
							admin_vars.admin_addDept_error = true;
							admin_vars.admin_add_department.visible = true;
						}
				}
				Hyperlink
				{
						text: "View Departments"
						layoutX: 30;
						layoutY: 150;
						action: function()
						{
							admin_sidepanel_visiblefalse();
							admin_vars.admin_view_department.visible = true;
						}
				}
				Hyperlink
				{
						text: "Add Designation"
						layoutX: 30;
						layoutY: 180;
						action: function()
						{
							admin_sidepanel_visiblefalse();
							admin_vars.admin_addDesig_name_field.text = "";
							admin_vars.admin_addDesig_desc_field.text = "";
							admin_vars.admin_addDesig_error = true;
							admin_vars.admin_add_designation.visible = true;
						}
			   }
			   Hyperlink
				{
						text: "View Designations"
						layoutX: 30;
						layoutY: 210;
						action: function()
						{
							admin_sidepanel_visiblefalse();
							admin_vars.admin_view_designation.visible = true;
						}
			   }
			   Hyperlink
				{
						text: "Add Product"
						layoutX: 30;
						layoutY: 240;
						action: function()
						{
							admin_sidepanel_visiblefalse();
							admin_vars.admin_addProduct.visible = true;
							admin_vars.admin_addProduct_error = true;
							admin_vars.admin_addProduct_name_field.text = "";
						}
				}
				Hyperlink
				{
						text: "View Products"
						layoutX: 30;
						layoutY: 270;
						action: function()
						{
							admin_sidepanel_visiblefalse();
							admin_vars.admin_view_product.visible = true;
						}
				}
				Hyperlink
				{
						text: "Add Manager"
						layoutX: 30;
						layoutY: 300;
						action: function()
						{
							admin_addmanager_valuenull();
							admin_sidepanel_visiblefalse();
							admin_vars.add_sales_manager = true;
							admin_vars.admin_add_manager.visible = true;
							admin_vars.scrollbar.visible = true;							
						}
				}
				Hyperlink
				{
						text: "View Managers"
						layoutX: 30;
						layoutY: 330;
						action: function()
						{
							admin_sidepanel_visiblefalse();
							admin_vars.admin_view_manager.visible = true;
						}
				}
				Hyperlink
				{
						text: "Logout"
						layoutX: 30;
						layoutY: 360;
						action: function()
						{
							admin_sidepanel_visiblefalse();
							sceneholder = mainscene;
							admin_vars.admin.visible = true;
							admin_vars.admin_unm_field.text= "";
							admin_vars.admin_pass_field.text = "";
							admin_vars.admin_side_panel.visible = false;
							admin_vars.main_side_panel.visible = true;
							admin_vars.msg = "";
						}
				}
			]
		}
	]
	visible:false;
}


//Administrator Code

// Main Panel


admin_vars.admin_unm_field = TextBox
{
	columns: 20;
	layoutX: 350;
	layoutY: 100;
	multiline: true;
	lines: 1;
	focusTraversable: true;
	onMouseEntered: function(e: MouseEvent):Void
	{
		admin_vars.admin_unm_field.columns = 30;
		admin_vars.admin_unm_field.translateX = 10;
	}   
	onMouseExited: function(e: MouseEvent):Void
	{
		admin_vars.admin_unm_field.columns = 20;
		admin_vars.admin_unm_field.translateX = 1;
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			admin_vars.admin_pass_field.requestFocus();			
			admin_vars.admin_unm_field.text = admin_vars.admin_unm_field.text.trim();
		}		
	}
}
admin_vars.admin_pass_field = PasswordBox
{
    columns: 20;
    layoutX: 350;
    layoutY: 130;
	transforms:
    [
        Scale {x: bind admin_vars.xCo, y: 1}
    ]
	focusTraversable: true;
    onMouseEntered: function(e: MouseEvent):Void
    {
		admin_vars.xCo = 1.5;
		admin_vars.admin_pass_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		admin_vars.xCo = 1;
		admin_vars.admin_pass_field.translateX = 1;
    }
}

admin_vars.admin = Panel
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
						text: "Administrator";
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
                    admin_vars.admin_unm_field,
                    Label
                    {
						id: "label";
                        text: "Password";
                        layoutX: 240;
                        layoutY: 130;
                    }
                    admin_vars.admin_pass_field,
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
						
							admin_vars.cs = admin_vars.cn.prepareCall("call admin_login(?,?,?)");
							admin_vars.cs.setString(1,'{admin_vars.admin_unm_field.text}');
							admin_vars.cs.registerOutParameter(2,Types.VARCHAR);
							admin_vars.cs.registerOutParameter(3,Types.VARCHAR);
							admin_vars.cs.execute();
							
							if(admin_vars.admin_unm_field.text == "")
							{
								admin_vars.msg = "* Username field cannot be empty";
							}
							else if(admin_vars.cs.getString(2).equals(admin_vars.admin_unm_field.text))
                            {
								if(admin_vars.cs.getString(3).equals(admin_vars.admin_pass_field.text))
								{
								    admin_vars.admin.visible = false;
									admin_vars.main_side_panel.visible = false;
									sceneholder = adminscene;
									admin_vars.admin_side_panel.visible = true;
									admin_vars.admin_afterlogin.visible = true;
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
                            admin_vars.admin_unm_field.text = "";
                            admin_vars.admin_pass_field.text = "";
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

// Administrator Main Page

admin_vars.admin_afterlogin = Panel
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
                    text: "Welcome Administrator";
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

// Add Department Code

admin_vars.admin_addDept_name_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 1;
	layoutX: 350;
	layoutY: 100;
	
    onMouseEntered: function(e: MouseEvent):Void
    {
		admin_vars.admin_addDept_name_field.columns = 30;
		admin_vars.admin_addDept_name_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		admin_vars.admin_addDept_name_field.columns = 20;
		admin_vars.admin_addDept_name_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(admin_vars.admin_addDept_error == false)
		{
			admin_vars.admin_addDept_name_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			admin_vars.admin_addDept_desc_field.requestFocus();
			admin_vars.admin_addDept_desc_field.text = admin_vars.admin_addDept_desc_field.text.trim();
		}
	}
}

admin_vars.admin_addDept_desc_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 5;
	layoutX: 350;
	layoutY: 130;
	
    onMouseEntered: function(e: MouseEvent):Void
    {
		admin_vars.admin_addDept_desc_field.columns = 30;
		admin_vars.admin_addDept_desc_field.translateX = 10;
	}   
    onMouseExited: function(e: MouseEvent):Void
    {
		admin_vars.admin_addDept_desc_field.columns = 20;
		admin_vars.admin_addDept_desc_field.translateX = 1;
	}
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(admin_vars.admin_addDept_error == false)
		{
			admin_vars.admin_addDept_desc_field.text = "";
		}
	}
}

admin_vars.admin_add_department = Panel
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
                    text: "Add Department";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
				{
					id: "label";
					text: "Name";
					layoutX: 250;
					layoutY: 100;					
				}
				admin_vars.admin_addDept_name_field,
				Label
				{
					id: "label";
					text: "Description";
					layoutX: 250;
					layoutY: 130;
				}
				admin_vars.admin_addDept_desc_field,
				Button
                    {
                        text: "Add";
                        layoutX: 350;
                        layoutY: 220;
                        transforms:
                        [
                            Scale {x: 1.2, y: 1.2}
                        ]
                        action: function()
                        {
							admin_vars.admin_addDept_error = true;
							if(admin_vars.admin_addDept_name_field.text.length() > 20)
							{
								admin_vars.admin_addDept_name_field.text = "* Too large value for Name field.";
								admin_vars.admin_addDept_error = false;
							}
							if(admin_vars.admin_addDept_desc_field.text.length() > 100)
							{
								admin_vars.admin_addDept_desc_field.text = "* Too large value for Description field.";
								admin_vars.admin_addDept_error = false;
							}
							if(admin_vars.admin_addDept_name_field.text == "")
							{
								admin_vars.admin_addDept_name_field.text = "* Name field cannot be empty.";
								admin_vars.admin_addDept_error = false;
							}
							if(admin_vars.admin_addDept_desc_field.text == "")
							{
								admin_vars.admin_addDept_desc_field.text = "* Description field cannot be empty.";
								admin_vars.admin_addDept_error = false;
							}
							if(admin_vars.admin_addDept_name_field.text != "" or admin_vars.admin_addDept_desc_field.text != "")
							{
								admin_vars.rs = admin_vars.st.executeQuery("select * from dept_master where name = '{admin_vars.admin_addDept_name_field.text}'");
								if(admin_vars.rs.next())
								{
									admin_vars.admin_addDept_error = false;
									admin_vars.admin_addDept_name_field.text = "Department already exists";
								}
							}
							if(admin_vars.admin_addDept_error == true)
							{								
								admin_vars.cs = admin_vars.cn.prepareCall("call ADD_DEPT_MASTER(?,?)");
								admin_vars.cs.setString(1,'{admin_vars.admin_addDept_name_field.text}');
								admin_vars.cs.setString(2,'{admin_vars.admin_addDept_desc_field.text}');
							
								if(admin_vars.cs.executeUpdate() == 0)
								{
									Alert.inform("The Department added successfully");
									insert admin_vars.admin_addDept_name_field.text into admin_vars.dept_choicebox_item;
									insert admin_vars.admin_addDept_desc_field.text into admin_vars.description;
									admin_vars.lv_dept_size = 30 * admin_vars.dept_choicebox_item.size();
									admin_vars.admin_addDept_name_field.text = "";
									admin_vars.admin_addDept_desc_field.text = "";									
								}
							}
                        }
                    }
			]
		}
	]
	visible:false;
}

// View Department

admin_vars.lv_dept_size = 30 * admin_vars.dept_choicebox_item.size();

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

admin_vars.viewDepartmentListView = ListView {
        items: bind [admin_vars.dept_choicebox_item]
		layoutInfo: LayoutInfo{height:bind admin_vars.lv_dept_size width: 700}
		layoutX: 50
		layoutY: 150
		
        cellFactory: function() {
            var listCell: ListCell;           
			
			if(admin_vars.dept_choicebox_item.size() > 5)
            {
                admin_vars.lv_dept_size = 30 * 5;
            }
            else
            {
                admin_vars.lv_dept_size = 30 * admin_vars.dept_choicebox_item.size();
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
                                    text: bind admin_vars.dept_choicebox_item[listCell.index]
                                    visible: bind not listCell.empty
                                }                                
                            ]
                        }
                         VBox {
							layoutInfo: LayoutInfo{width: 400}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl2"
                                    text: bind admin_vars.description[listCell.index]
                                    visible: bind not listCell.empty
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
                                    visible: bind not listCell.empty
                                    action: function() {
                                        admin_vars.cs = admin_vars.cn.prepareCall("call delete_dept(?)");
                                        admin_vars.cs.setString(1,'{admin_vars.dept_choicebox_item[listCell.index]}');
                                        admin_vars.cs.executeUpdate();
                                        delete admin_vars.dept_choicebox_item[listCell.index] from admin_vars.dept_choicebox_item;
                                        delete admin_vars.description[listCell.index] from admin_vars.description;
										admin_vars.lv_dept_size = 30 * admin_vars.dept_choicebox_item.size();
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
	
admin_vars.admin_view_department = Panel
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
                    text: "Departments";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
				{
					text: "You have not added any department yet.";
                    layoutX: 220;
                    layoutY: 150;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (admin_vars.viewDepartmentListView.height == 0)
				}
				ListView
				{
					layoutInfo: LayoutInfo{width: 700 height: 30}
					layoutX: 50
					layoutY: 100
					visible: bind not (admin_vars.viewDepartmentListView.height == 0)
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
											visible: bind not (admin_vars.viewDepartmentListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 400}
									spacing: 10
									content: [
										Label {
											text: "Description"
											font:Font.font("CALIBRI", FontWeight.BOLD, 20);
											visible: bind not (admin_vars.viewDepartmentListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 90}
									spacing: 10
									content: [          
										Label {
											text: "Delete"
											font:Font.font("CALIBRI", FontWeight.BOLD, 20);
											visible: bind not (admin_vars.viewDepartmentListView.height == 0)
										}
									]
									}
								]
							}
						}
					}
				}
				admin_vars.viewDepartmentListView,
			]
		}
	]
	visible: false;
}

// Add Designation

admin_vars.admin_addDesig_name_field = TextBox
{
	columns: 20;
	layoutX: 350;
	layoutY: 100;
	multiline: true;
	lines:1;
	
    onMouseEntered: function(e: MouseEvent):Void
    {
		admin_vars.admin_addDesig_name_field.columns = 30;
		admin_vars.admin_addDesig_name_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		admin_vars.admin_addDesig_name_field.columns = 20;
		admin_vars.admin_addDesig_name_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(admin_vars.admin_addDesig_error == false)
		{
			admin_vars.admin_addDesig_name_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			admin_vars.admin_addDesig_desc_field.requestFocus();
			admin_vars.admin_addDesig_name_field.text = admin_vars.admin_addDesig_name_field.text.trim();
		}
	}
}
admin_vars.admin_addDesig_desc_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 5;
	layoutX: 350;
	layoutY: 130;
	
	onMouseEntered: function(e: MouseEvent):Void
    {
		admin_vars.admin_addDesig_desc_field.columns = 30;
		admin_vars.admin_addDesig_desc_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		admin_vars.admin_addDesig_desc_field.columns = 20;
		admin_vars.admin_addDesig_desc_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(admin_vars.admin_addDesig_error == false)
		{
			admin_vars.admin_addDesig_desc_field.text = "";
		}
	}
}

admin_vars.admin_add_designation = Panel
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
                        text: "Add Designation";
                        layoutX: 320;
                        layoutY: 40;
                        font:Font.font("ARIAL", FontWeight.BOLD, 20);
                        effect:Glow {level:0.5};
                    }
				Label
				{
					id: "label";
					text: "Name";
					layoutX: 250;
					layoutY: 100;
				}
				admin_vars.admin_addDesig_name_field,
				Label
				{
					id: "label";
					text: "Description";
					layoutX: 250;
					layoutY: 130;
				}
				admin_vars.admin_addDesig_desc_field,
				Button
                    {
                        text: "Add";
                        layoutX: 350;
						layoutY: 220;
                        transforms:
                        [
                            Scale {x: 1.2, y: 1.2}
                        ]
                        action: function()
                        {
							admin_vars.admin_addDesig_error = true;
							if(admin_vars.admin_addDesig_name_field.text.length() > 20)
							{
								admin_vars.admin_addDesig_name_field.text = "* Too large value for Name field.";
								admin_vars.admin_addDesig_error = false;
							}
							if(admin_vars.admin_addDesig_desc_field.text.length() > 100)
							{
								admin_vars.admin_addDesig_desc_field.text = "* Too large value for Description field.";
								admin_vars.admin_addDesig_error = false;
							}
							if(admin_vars.admin_addDesig_name_field.text == "")
							{
								admin_vars.admin_addDesig_name_field.text = "* Name field cannot be empty.";
								admin_vars.admin_addDesig_error = false;
							}
							if(admin_vars.admin_addDesig_desc_field.text == "")
							{
								admin_vars.admin_addDesig_desc_field.text = "* Description field cannot be empty.";
								admin_vars.admin_addDesig_error = false;
							}
							if(admin_vars.admin_addDesig_name_field.text != "" or admin_vars.admin_addDesig_desc_field.text != "")
							{
								admin_vars.rs = admin_vars.st.executeQuery("select * from desig_master where name = '{admin_vars.admin_addDesig_name_field.text}'");
								if(admin_vars.rs.next())
								{
									admin_vars.admin_addDesig_error = false;
									admin_vars.admin_addDesig_name_field.text = "Designation already exists";
								}
							}
							if(admin_vars.admin_addDesig_error == true)
							{
								admin_vars.cs = admin_vars.cn.prepareCall("call ADD_DESIG_MASTER(?,?)");
								admin_vars.cs.setString(1,'{admin_vars.admin_addDesig_name_field.text}');
								admin_vars.cs.setString(2,'{admin_vars.admin_addDesig_desc_field.text}');
								if(admin_vars.cs.executeUpdate() == 0)
								{
									Alert.inform("The Designation added successfully");
									insert admin_vars.admin_addDesig_name_field.text into admin_vars.desig_choicebox_item;
									insert admin_vars.admin_addDesig_desc_field.text into admin_vars.desig_description;
									admin_vars.lv_desig_size = 30 * admin_vars.desig_choicebox_item.size();
									admin_vars.admin_addDesig_name_field.text = "";
									admin_vars.admin_addDesig_desc_field.text = "";									
								}
							}
                        }
                    }
			]
		}
	]
	visible:false;
}

// View Designation

admin_vars.rs1 = admin_vars.st.executeQuery("select Name,Description from DESIG_MASTER");
while(admin_vars.rs1.next())
{
	insert admin_vars.rs1.getString(1).toString() into admin_vars.desig_choicebox_item;							
	insert admin_vars.rs1.getString(2).toString() into admin_vars.desig_description;
}
admin_vars.lv_desig_size = 30 * admin_vars.desig_choicebox_item.size();

admin_vars.viewDesignationListView = ListView {
        items: bind [admin_vars.desig_choicebox_item]
		layoutInfo: LayoutInfo{height:bind admin_vars.lv_desig_size width: 700}
		layoutX: 50
		layoutY: 150
		
        cellFactory: function() {
            var listCell: ListCell;           
			
			if(admin_vars.desig_choicebox_item.size() > 5)
            {
                admin_vars.lv_desig_size = 30 * 5;
            }
            else
            {
                admin_vars.lv_desig_size = 30 * admin_vars.desig_choicebox_item.size();
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
                                    text: bind admin_vars.desig_choicebox_item[listCell.index]
                                    visible: bind not listCell.empty
                                }                                
                            ]
                        }
                         VBox {
							layoutInfo: LayoutInfo{width: 400}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl2"
                                    text: bind admin_vars.desig_description[listCell.index]
                                    visible: bind not listCell.empty
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
                                    visible: bind not listCell.empty
                                    action: function() {
                                        admin_vars.cs = admin_vars.cn.prepareCall("call delete_desig(?)");
                                        admin_vars.cs.setString(1,'{admin_vars.desig_choicebox_item[listCell.index]}');
                                        admin_vars.cs.executeUpdate();
                                        delete admin_vars.desig_choicebox_item[listCell.index] from admin_vars.desig_choicebox_item;
                                        delete admin_vars.desig_description[listCell.index] from admin_vars.desig_description;
										admin_vars.lv_desig_size = 30 * admin_vars.desig_choicebox_item.size();
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
	
admin_vars.admin_view_designation = Panel
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
                    text: "Designations";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
				{
					text: "You have not added any designations yet.";
                    layoutX: 220;
                    layoutY: 150;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (admin_vars.viewDesignationListView.height == 0)
				}
				ListView
				{
					layoutInfo: LayoutInfo{width: 700 height: 30}
					layoutX: 50
					layoutY: 100
					visible: bind not (admin_vars.viewDesignationListView.height == 0)
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
											visible: bind not (admin_vars.viewDesignationListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 400}
									spacing: 10
									content: [
										Label {
											text: "Description"
											font:Font.font("CALIBRI", FontWeight.BOLD, 20);
											visible: bind not (admin_vars.viewDesignationListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 90}
									spacing: 10
									content: [          
										Label {
											text: "Delete"
											font:Font.font("CALIBRI", FontWeight.BOLD, 20);
											visible: bind not (admin_vars.viewDesignationListView.height == 0)
										}
									]
									}
								]
							}
						}
					}
				}
				admin_vars.viewDesignationListView,
			]
		}
	]
	visible: false;
}

// Add Product

admin_vars.admin_addProduct_name_field = TextBox
{
	columns: 20;
	layoutX: 350;
	layoutY: 100;
	multiline:true;
	lines:1;
	
    onMouseEntered: function(e: MouseEvent):Void
    {
		admin_vars.admin_addProduct_name_field.columns = 30;
		admin_vars.admin_addProduct_name_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		admin_vars.admin_addProduct_name_field.columns = 20;
		admin_vars.admin_addProduct_name_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(admin_vars.admin_addProduct_error == false)
		{
			admin_vars.admin_addProduct_name_field.text = "";
		}
	}
}
admin_vars.admin_addProduct_qty = Label
{
	text: "0"
	layoutX: 350;
	layoutY: 130;
	font: Font.font("CALIBRI",FontWeight.BOLD,20);
}

admin_vars.admin_addProduct = Panel
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
                        text: "Add Product";
                        layoutX: 320;
                        layoutY: 40;
                        font:Font.font("ARIAL", FontWeight.BOLD, 20);
                        effect:Glow {level:0.5};
                    }
				Label
				{
					id: "label";
					text: "Product Name";
					layoutX: 230;
					layoutY: 100;
				}
				admin_vars.admin_addProduct_name_field,
				Label
				{
					id: "label";
					text: "Quantity";
					layoutX: 230;
					layoutY: 130;
				}
				admin_vars.admin_addProduct_qty,
				Button
                    {
                        text: "Add";
                        layoutX: 350;
						layoutY: 160;
                        transforms:
                        [
                            Scale {x: 1.2, y: 1.2}
                        ]
                        action: function()
                        {
							admin_vars.admin_addProduct_error = true;
							if(admin_vars.admin_addProduct_name_field.text.length() > 20)
							{
								admin_vars.admin_addProduct_name_field.text = "* Too large value for Name field";
								admin_vars.admin_addProduct_error = false;
							}
							if(admin_vars.admin_addProduct_name_field.text == "")
							{
								admin_vars.admin_addProduct_name_field.text = "* Name field cannot be empty";
								admin_vars.admin_addProduct_error = false;
							}							
							admin_vars.rs1 = admin_vars.st.executeQuery("select Name from PRODUCT_MASTER where Name = '{admin_vars.admin_addProduct_name_field.text}'");
							if(admin_vars.rs1.next())
							{
								Alert.inform("Product already exists.");
								admin_vars.admin_addProduct_error = false;
							}
							if(admin_vars.admin_addProduct_error == true)
							{								
								admin_vars.cs = admin_vars.cn.prepareCall("call ADD_PRODUCT_MASTER(?,?)");
								admin_vars.cs.setString(1,'{admin_vars.admin_addProduct_name_field.text}');
								admin_vars.cs.setString(2,'{admin_vars.admin_addProduct_qty.text}');
																
								if(admin_vars.cs.executeUpdate() == 0)
								{
									Alert.inform("The Product added successfully");
									insert {admin_vars.admin_addProduct_name_field.text} into admin_vars.prod_name;
									insert {admin_vars.admin_addProduct_qty.text} into admin_vars.prod_qty;
									admin_vars.lv_prod_size = 30 * admin_vars.prod_name.size();
									admin_vars.admin_addProduct_name_field.text = "";									
								}
							}
                        }
                    }
			]
		}
	]
	visible:false;
}

// View Product

admin_vars.rs1 = admin_vars.st.executeQuery("select Name,Quantity from PRODUCT_MASTER");
while(admin_vars.rs1.next())
{
	insert admin_vars.rs1.getString(1).toString() into admin_vars.prod_name;							
	insert admin_vars.rs1.getString(2).toString() into admin_vars.prod_qty;
}
admin_vars.lv_prod_size = 30 * admin_vars.prod_name.size();

admin_vars.viewProductListView = ListView {
        items: bind [admin_vars.prod_name]
		layoutInfo: LayoutInfo{height:bind admin_vars.lv_prod_size width: 460}
		layoutX: 150
		layoutY: 150
		
        cellFactory: function() {
            var listCell: ListCell;           
			
			if(admin_vars.prod_name.size() > 5)
            {
                admin_vars.lv_prod_size = 30 * 5;
            }
            else
            {
                admin_vars.lv_prod_size = 30 * admin_vars.prod_name.size();
            }
            listCell = ListCell {
                node : HBox {
					content: [
                         VBox {
							layoutInfo: LayoutInfo{width: 250}
			                spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind admin_vars.prod_name[listCell.index]
                                    visible: bind not listCell.empty and not admin_vars.lv_prod_flag or not listCell.selected or (admin_vars.lv_prod_ind != listCell.index)
                                }
                            ]
                        }
                         VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl2"
                                    text: bind admin_vars.prod_qty[listCell.index]
                                    visible: bind not listCell.empty and not admin_vars.lv_prod_flag or not listCell.selected or (admin_vars.lv_prod_ind != listCell.index)
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
                                    visible: bind not listCell.empty and (not admin_vars.lv_prod_flag or not listCell.selected or (admin_vars.lv_prod_ind != listCell.index))
                                    action: function() {
                                        admin_vars.cs = admin_vars.cn.prepareCall("call delete_prod(?)");
                                        admin_vars.cs.setString(1,'{admin_vars.prod_name[listCell.index]}');
                                        admin_vars.cs.executeUpdate();
                                        delete admin_vars.prod_name[listCell.index] from admin_vars.prod_name;
										admin_vars.prod_qty[listCell.index] = "";
                                        delete "" from admin_vars.prod_qty;
										admin_vars.lv_prod_size = 30 * admin_vars.prod_name.size();
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
	
admin_vars.admin_view_product = Panel
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
                    text: "Products";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
				{
					text: "You have not added any products yet.";
                    layoutX: 220;
                    layoutY: 150;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (admin_vars.viewProductListView.height == 0)
				}
				ListView
				{
					layoutInfo: LayoutInfo{width: 460 height: 30}
					layoutX: 150
					layoutY: 100
					visible: bind not (admin_vars.viewProductListView.height == 0)
					cellFactory: function() {
						var listCell: ListCell = ListCell
						{
							node : HBox {
								content: [
									VBox {
									layoutInfo: LayoutInfo{width: 250}
									spacing: 10
									content: [
										Label {
											text: "Product Name"
											font:Font.font("CALIBRI", FontWeight.BOLD, 20);
											visible: bind not (admin_vars.viewProductListView.height == 0)
										}
									]
									}
									VBox {
									layoutInfo: LayoutInfo{width: 100}
									spacing: 10
									content: [
										Label {
											text: "Quantity"
											font:Font.font("CALIBRI", FontWeight.BOLD, 20);
											visible: bind not (admin_vars.viewProductListView.height == 0)
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
											visible: bind not (admin_vars.viewProductListView.height == 0)
										}
									]
									}
								]
							}
						}
					}
				}
				admin_vars.viewProductListView,
			]
		}
	]
	visible: false;
}


// Add Manager

admin_vars.EMAIL_PATTERN = "^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+$";
admin_vars.pattern = Pattern.compile(admin_vars.EMAIL_PATTERN);

admin_vars.PHONE_PATTERN = "^[0-9]+$"; //new 19-04
admin_vars.phonepattern = Pattern.compile(admin_vars.PHONE_PATTERN);

admin_vars.admin_addManager_fnm_field = TextBox
{
	columns: 20;
	layoutX: 350;
	layoutY: 100;
	multiline:true;
	lines:1;
	
    onMouseEntered: function(e: MouseEvent):Void
    {
		admin_vars.admin_addManager_fnm_field.columns = 30;
		admin_vars.admin_addManager_fnm_field.translateX = 10;
    }   
    onMouseExited: function(e: MouseEvent):Void
    {
		admin_vars.admin_addManager_fnm_field.columns = 20;
		admin_vars.admin_addManager_fnm_field.translateX = 1;
    }
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(admin_vars.add_sales_manager == false)
		{
			admin_vars.admin_addManager_fnm_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			admin_vars.admin_addManager_mnm_field.requestFocus();
			admin_vars.admin_addManager_fnm_field.text = admin_vars.admin_addManager_fnm_field.text.trim();
		}
	}
}
admin_vars.admin_addManager_mnm_field = TextBox
{
	columns: 20;
	layoutX: 350;
	layoutY: 130;
	multiline:true;
	lines:1;
	
    onMouseEntered: function(e: MouseEvent):Void
    {
		admin_vars.admin_addManager_mnm_field.columns = 30;
		admin_vars.admin_addManager_mnm_field.translateX = 10;
    }   
	onMouseExited: function(e: MouseEvent):Void
	{
		admin_vars.admin_addManager_mnm_field.columns = 20;
		admin_vars.admin_addManager_mnm_field.translateX = 1;
	}
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(admin_vars.add_sales_manager == false)
		{
			admin_vars.admin_addManager_mnm_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			admin_vars.admin_addManager_lnm_field.requestFocus();
			admin_vars.admin_addManager_mnm_field.text = admin_vars.admin_addManager_mnm_field.text.trim();
		}
	}
}
admin_vars.admin_addManager_lnm_field = TextBox
{
	columns: 20;
	layoutX: 350;
	layoutY: 160;
	multiline:true;
	lines:1;
	
	onMouseEntered: function(e: MouseEvent):Void
	{
		admin_vars.admin_addManager_lnm_field.columns = 30;
		admin_vars.admin_addManager_lnm_field.translateX = 10;
	}   
	onMouseExited: function(e: MouseEvent):Void
	{
		admin_vars.admin_addManager_lnm_field.columns = 20;
		admin_vars.admin_addManager_lnm_field.translateX = 1;
	}
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(admin_vars.add_sales_manager == false)
		{
			admin_vars.admin_addManager_lnm_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			admin_vars.admin_addManager_unm_field.requestFocus();
			admin_vars.admin_addManager_lnm_field.text = admin_vars.admin_addManager_lnm_field.text.trim();
		}
	}
}
admin_vars.admin_addManager_unm_field = TextBox
{
	columns: 20;
	layoutX: 350;
	layoutY: 190;
	multiline:true;
	lines:1;
	
	onMouseEntered: function(e: MouseEvent):Void
	{
		admin_vars.admin_addManager_unm_field.columns = 30;
		admin_vars.admin_addManager_unm_field.translateX = 10;
	}   
	onMouseExited: function(e: MouseEvent):Void
	{
		admin_vars.admin_addManager_unm_field.columns = 20;
		admin_vars.admin_addManager_unm_field.translateX = 1;
	}
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(admin_vars.add_sales_manager == false)
		{
			admin_vars.admin_addManager_unm_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			admin_vars.admin_addManager_pass_field.requestFocus();
			admin_vars.admin_addManager_unm_field.text = admin_vars.admin_addManager_unm_field.text.trim();
		}
	}
}
admin_vars.admin_addManager_pass_field = PasswordBox
{
	columns: 20;
	layoutX: 350;
	layoutY: 220;
	transforms:
    [
        Scale {x: bind admin_vars.xCo, y: 1}
    ]
	onMouseEntered: function(e: MouseEvent):Void
	{
		admin_vars.xCo = 1.5;
	}   
	onMouseExited: function(e: MouseEvent):Void
	{
		admin_vars.xCo = 1;
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			admin_vars.admin_addManager_Malegender.requestFocus();
		}
	}
}

def admin_addManager_gender = ToggleGroup {};
admin_vars.admin_addManager_Malegender = RadioButton
{
        text: "Male"
		toggleGroup: admin_addManager_gender;
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
				admin_vars.admin_addManager_Femalegender.requestFocus();				
			}
		}
}

admin_vars.admin_addManager_Femalegender = RadioButton
{
    text: "Female"
	toggleGroup: admin_addManager_gender;
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
			admin_vars.addsalesmanagerbirthyear.requestFocus();
		}
	}
}
for(k in [1975..2000])
{
    insert k.toString() into admin_vars.yy;
}
admin_vars.addsalesmanagerbirthdate = ChoiceBox
{
	layoutX: 435;
	layoutY: 310;
	items: bind ["   ",admin_vars.dd]
	disable: bind (admin_vars.addsalesmanagerbirthmonth.selectedIndex == -1);
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			admin_vars.admin_addManager_deptchoicebox.requestFocus();
		}
	}
}
admin_vars.addsalesmanagerbirthmonth = ChoiceBox
{
	layoutX: 350;
	layoutY: 310;
	items:["JAN","FEB","MAR","APR","MAY","JUNE","JULY","AUG","SEP","OCT","NOV","DEC"]
	disable: bind (admin_vars.addsalesmanagerbirthyear.selectedIndex == -1);
	
	onMouseExited: function(e: MouseEvent): Void
	{
		delete admin_vars.dd;
		if(admin_vars.addsalesmanagerbirthmonth.selectedItem.toString() == "FEB")
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
		if(admin_vars.addsalesmanagerbirthmonth.selectedItem.toString() == "JAN" or admin_vars.addsalesmanagerbirthmonth.selectedItem.toString() == "MAR" or admin_vars.addsalesmanagerbirthmonth.selectedItem.toString() == "MAY" or admin_vars.addsalesmanagerbirthmonth.selectedItem.toString() == "JULY" or admin_vars.addsalesmanagerbirthmonth.selectedItem.toString() == "AUG" or admin_vars.addsalesmanagerbirthmonth.selectedItem.toString() == "OCT" or admin_vars.addsalesmanagerbirthmonth.selectedItem.toString() == "DEC")
		{
			for(i in [1..31] )
			{
				insert i.toString() into admin_vars.dd;
			}
		}
		if(admin_vars.addsalesmanagerbirthmonth.selectedItem.toString() == "APR" or admin_vars.addsalesmanagerbirthmonth.selectedItem.toString() == "JUNE" or admin_vars.addsalesmanagerbirthmonth.selectedItem.toString() == "SEP" or admin_vars.addsalesmanagerbirthmonth.selectedItem.toString() == "NOV")
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
			admin_vars.addsalesmanagerbirthdate.requestFocus();
		}
	}
}
admin_vars.addsalesmanagerbirthyear = ChoiceBox
{
	id: "cb";
	layoutX: 383;
	layoutY: 280;
	scaleX: 1.9;
	items:[admin_vars.yy]
	onMouseExited: function(e: MouseEvent): Void
	{
		if(admin_vars.addsalesmanagerbirthyear.selectedItem.toString() != "")
		{
			if((Integer.parseInt(admin_vars.addsalesmanagerbirthyear.selectedItem.toString()) mod 4) == 0)
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
			admin_vars.addsalesmanagerbirthmonth.requestFocus();
		}
	}
}

admin_vars.admin_addManager_deptchoicebox = ChoiceBox
{
	layoutX: 377;
	layoutY: 340;
	scaleX: 1.5;                                        
	items: bind [admin_vars.dept_choicebox_item];
	layoutInfo: LayoutInfo { width: 100 };
	
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			admin_vars.admin_addManager_phoneno_field.requestFocus();
		}
	}
}
admin_vars.admin_addManager_phoneno_field = TextBox
{
	columns: 20;
	layoutX: 350;
	layoutY: 370;
	multiline:true;
	lines:1;
	
	onMouseEntered: function(e: MouseEvent):Void
	{
		admin_vars.admin_addManager_phoneno_field.columns = 30;
		admin_vars.admin_addManager_phoneno_field.translateX = 10;
	}   
	onMouseExited: function(e: MouseEvent):Void
	{
		admin_vars.admin_addManager_phoneno_field.columns = 20;
		admin_vars.admin_addManager_phoneno_field.translateX = 1;
	}
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(admin_vars.add_sales_manager == false)
		{
			admin_vars.admin_addManager_phoneno_field.text = "";			
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			admin_vars.admin_addManager_email_field.requestFocus();
			admin_vars.admin_addManager_phoneno_field.text = admin_vars.admin_addManager_phoneno_field.text.trim();
		}
	}
}
admin_vars.admin_addManager_email_field = TextBox
{
	columns: 20;
	layoutX: 350;
	layoutY: 400;
	multiline:true;
	lines:1;
	
	onMouseEntered: function(e: MouseEvent):Void
	{
		admin_vars.admin_addManager_email_field.columns = 30;
		admin_vars.admin_addManager_email_field.translateX = 10;
	}   
	onMouseExited: function(e: MouseEvent):Void
	{
		admin_vars.admin_addManager_email_field.columns = 20;
		admin_vars.admin_addManager_email_field.translateX = 1;
	}
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(admin_vars.add_sales_manager == false)
		{
			admin_vars.admin_addManager_email_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			admin_vars.admin_addManager_address_field.requestFocus();
			admin_vars.admin_addManager_email_field.text = admin_vars.admin_addManager_email_field.text.trim();
		}
	}
}
admin_vars.admin_addManager_address_field = TextBox
{
	columns: 20;
	multiline: true;
	lines: 3;
	layoutX: 350;
	layoutY: 430;
	
	onMouseEntered: function(e: MouseEvent):Void
	{
		admin_vars.admin_addManager_address_field.columns = 30;
		admin_vars.admin_addManager_address_field.translateX = 10;
	}   
	onMouseExited: function(e: MouseEvent):Void
	{
		admin_vars.admin_addManager_address_field.columns = 20;
		admin_vars.admin_addManager_address_field.translateX = 1;
	}
	onMouseClicked: function(e: MouseEvent):Void
	{
		if(admin_vars.add_sales_manager == false)
		{
			admin_vars.admin_addManager_address_field.text = "";
		}
	}
	onKeyPressed: function(e: KeyEvent):Void
	{
		if(e.code.toString() == "VK_TAB")
		{
			admin_vars.admin_addManager_address_field.text = admin_vars.admin_addManager_address_field.text.trim();
		}
	}
}
admin_vars.scrollbar = ScrollBar
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
admin_vars.selectedfilelabel = Label
{
	id: "label";
	text: "No File Selected.";
	layoutX: 500;
	layoutY: 490;
}

admin_vars.admin_add_manager = Panel
{
	content : 
	[
		Panel
		{
			layoutX: 200,
			layoutY:bind -(admin_vars.scrollbar.value)+100,
			height: 550,
			width: 800
			content:
			[
				Label
                    {
                        text: "Add Manager";
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
				admin_vars.admin_addManager_fnm_field,
				Label
				{
					id: "label";
					text: "Middle Name";
					layoutX: 240;
					layoutY: 130;
				}
				admin_vars.admin_addManager_mnm_field,
				Label
				{
					id: "label";
					text: "Last Name";
					layoutX: 240;
					layoutY: 160;
				}
				admin_vars.admin_addManager_lnm_field,
				Label
				{
					id: "label";
					text: "User Name";
					layoutX: 240;
					layoutY: 190;
				}
				admin_vars.admin_addManager_unm_field,
				Label
				{
					id: "label";
					text: "Password";
					layoutX: 240;
					layoutY: 220;
				}
				admin_vars.admin_addManager_pass_field,
				Label
				{
					id: "label";
					text: "Gender";
					layoutX: 240;
					layoutY: 250;
				}
				admin_vars.admin_addManager_Malegender,
				admin_vars.admin_addManager_Femalegender,
                Label
				{
					id: "label";
					text: "Birthdate";
					layoutX: 240;
					layoutY: 280;
				}
				admin_vars.addsalesmanagerbirthdate,
				admin_vars.addsalesmanagerbirthmonth,
				admin_vars.addsalesmanagerbirthyear,
				Label
				{
					id: "label";
					text: "Department";
					layoutX: 240;
					layoutY: 340;
				}
				admin_vars.admin_addManager_deptchoicebox,
				Label
				{
					id: "label";
					text: "Phone No";
					layoutX: 240;
					layoutY: 370;
				}
				admin_vars.admin_addManager_phoneno_field,
				Label
				{
					id: "label";
					text: "Email ID";
					layoutX: 240;
					layoutY: 400;
				}
				admin_vars.admin_addManager_email_field,
				Label
				{
					id: "label";
					text: "Address";
					layoutX: 240;
					layoutY: 430;
				}
				admin_vars.admin_addManager_address_field,
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
								admin_vars.selectedfilelabel.text = fileobj.getName();
								admin_vars.image = ImageIO.read(fileobj);
							}
							else
							{
								Alert.inform("Select JPEG files.");
								admin_vars.add_sales_manager = false;
							}							
						}						
					}
				}
				admin_vars.selectedfilelabel,
				Button
                    {
                        text: "Add";
                        layoutX: 350;
						layoutY: 520;
                        transforms:
                        [
                            Scale {x: 1.2, y: 1.2}
                        ]
                        action: function()
                        {
							admin_vars.add_sales_manager = true;
							if(admin_vars.admin_addManager_fnm_field.text == "")
							{
								admin_vars.admin_addManager_fnm_field.text = "* First Name cannot be empty";
								admin_vars.add_sales_manager = false;
							}
							if(admin_vars.admin_addManager_mnm_field.text == "")
							{
								admin_vars.admin_addManager_mnm_field.text = "* Middle Name cannot be empty";
								admin_vars.add_sales_manager = false;
							}
							if(admin_vars.admin_addManager_lnm_field.text == "")
							{
								admin_vars.admin_addManager_lnm_field.text = "* Last Name cannot be empty";
								admin_vars.add_sales_manager = false;
							}
							if(admin_vars.addsalesmanagerbirthdate.selectedIndex == -1 or admin_vars.addsalesmanagerbirthmonth.selectedIndex == -1 or admin_vars.addsalesmanagerbirthyear.selectedIndex == -1 or admin_vars.addsalesmanagerbirthdate.selectedItem == "   ")
							{
								Alert.inform("Select Birthdate.");
								admin_vars.add_sales_manager = false;
							}
							if(admin_vars.admin_addManager_deptchoicebox.selectedIndex == -1)
							{
								Alert.inform("Select Department.");
								admin_vars.add_sales_manager = false;
							}
							if(admin_vars.admin_addManager_unm_field.text == "")
							{
								admin_vars.admin_addManager_unm_field.text = "* User Name cannot be empty";
								admin_vars.add_sales_manager = false;					
							}
							else
							{
								admin_vars.rs = admin_vars.st.executeQuery("select * from salesmanager_master where username = '{admin_vars.admin_addManager_unm_field.text.toString()}'");
								if(admin_vars.rs.next())
								{
									admin_vars.add_sales_manager = false;
									admin_vars.admin_addManager_unm_field.text = "* User Name already exists";
								}
							}
							if(admin_vars.admin_addManager_pass_field.text == "")
							{
								admin_vars.admin_addManager_pass_field.text = "";
								admin_vars.add_sales_manager = false;
							}							
							if(admin_vars.admin_addManager_phoneno_field.text.length() < 10 or admin_vars.admin_addManager_phoneno_field.text.length() > 10)
							{
								admin_vars.admin_addManager_phoneno_field.text = "* Phone no must be 10 digits long.";
								admin_vars.add_sales_manager = false;
							}
							else
							{
								admin_vars.matcher = admin_vars.phonepattern.matcher(admin_vars.admin_addManager_phoneno_field.text);
								if(admin_vars.matcher.matches())
								{
								}
								else
								{
									admin_vars.admin_addManager_phoneno_field.text = "* Invalid Phone no.";
									admin_vars.add_sales_manager = false;
								}
							}							
							if(admin_vars.admin_addManager_email_field.text == "")
							{
								admin_vars.admin_addManager_email_field.text = "* Email cannot be empty";
								admin_vars.add_sales_manager = false;								
							}							
							else 
							{
								admin_vars.matcher = admin_vars.pattern.matcher(admin_vars.admin_addManager_email_field.text);
								if(admin_vars.matcher.matches())
								{
								}
								else
								{
									admin_vars.admin_addManager_email_field.text = "* Email is not valid";
									admin_vars.add_sales_manager = false;
								}
							}
							if(admin_vars.admin_addManager_address_field.text == "")
							{
								admin_vars.admin_addManager_address_field.text = "* Address cannot be empty";
								admin_vars.add_sales_manager = false;
							}
							
							if(admin_vars.add_sales_manager == true)
							{
								admin_vars.cs = admin_vars.cn.prepareCall("call add_salesmanager_master(?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
								admin_vars.cs.setString(1,'{admin_vars.admin_addManager_fnm_field.text}');
								admin_vars.cs.setString(2,'{admin_vars.admin_addManager_mnm_field.text}');
								admin_vars.cs.setString(3,'{admin_vars.admin_addManager_lnm_field.text}');
								admin_vars.cs.setString(4,'{admin_vars.admin_addManager_unm_field.text}');
								admin_vars.cs.setString(5,'{admin_vars.admin_addManager_pass_field.text}');
								admin_vars.cs.setString(6,'{(admin_addManager_gender.selectedToggle as RadioButton).text}');
								admin_vars.cs.setString(7,'{admin_vars.addsalesmanagerbirthdate.selectedItem}');
								admin_vars.cs.setString(8,'{admin_vars.addsalesmanagerbirthmonth.selectedItem}');
								admin_vars.cs.setString(9,'{admin_vars.addsalesmanagerbirthyear.selectedItem}');
								admin_vars.cs.setString(10,'{admin_vars.admin_addManager_deptchoicebox.selectedItem}');
								admin_vars.cs.setString(11,'{admin_vars.admin_addManager_phoneno_field.text}');
								admin_vars.cs.setString(12,'{admin_vars.admin_addManager_email_field.text}');
								admin_vars.cs.setString(13,'{admin_vars.admin_addManager_address_field.text}');
								admin_vars.cs.setString(14,"{admin_vars.admin_addManager_unm_field.text}.jpg");
								
								if(admin_vars.cs.executeUpdate() == 0)
								{
									var targetFile: File;
									targetFile = new File("../Manager/userpic/{admin_vars.admin_addManager_unm_field.text}.jpg");
									ImageIO.write(admin_vars.image, "jpg", targetFile);
									
									Alert.inform("Manager Data inserted successfully.");
									insert "{admin_vars.admin_addManager_fnm_field.text} {admin_vars.admin_addManager_mnm_field.text} {admin_vars.admin_addManager_lnm_field.text}" into admin_vars.sm_name;
									insert {admin_vars.admin_addManager_unm_field.text} into admin_vars.sm_unm;
									insert "{admin_vars.addsalesmanagerbirthdate.selectedItem}/{admin_vars.addsalesmanagerbirthmonth.selectedItem}/{admin_vars.addsalesmanagerbirthyear.selectedItem}" into admin_vars.sm_bdate;
									insert {admin_vars.admin_addManager_phoneno_field.text} into admin_vars.sm_phoneno;
									insert {admin_vars.admin_addManager_email_field.text} into admin_vars.sm_email;
									insert "{admin_vars.admin_addManager_deptchoicebox.selectedItem}" into admin_vars.sm_dept;
									admin_vars.lv_man_size = 30 * admin_vars.sm_unm.size();
									admin_addmanager_valuenull();
								}
							}
                        }
                    }
			]
		}
	]
	visible: false;
}

// View Manager

admin_vars.rs1 = admin_vars.st.executeQuery("select * from salesmanager_master");
while(admin_vars.rs1.next())
{
	insert "{admin_vars.rs1.getString(2).toString()} {admin_vars.rs1.getString(3).toString()} {admin_vars.rs1.getString(4).toString()}" into admin_vars.sm_name;	
	insert {admin_vars.rs1.getString(5).toString()} into admin_vars.sm_unm;
	insert "{admin_vars.rs1.getString(8).toString()}-{admin_vars.rs1.getString(9).toString()}-{admin_vars.rs1.getString(10).toString()}" into admin_vars.sm_bdate;	
	insert {admin_vars.rs1.getString(11).toString()} into admin_vars.sm_dept;
	insert {admin_vars.rs1.getString(12).toString()} into admin_vars.sm_phoneno;
	insert {admin_vars.rs1.getString(13).toString()} into admin_vars.sm_email;
}
admin_vars.lv_man_size = 30 * admin_vars.sm_unm.size();
admin_vars.viewManagerListView = ListView {
        items: bind [admin_vars.sm_unm]
		layoutInfo: LayoutInfo{height:bind admin_vars.lv_man_size width: 750}
		layoutX: 20
		layoutY: 150
		
        cellFactory: function() {
            var listCell: ListCell;           
			
			if(admin_vars.sm_unm.size() > 5)
            {
                admin_vars.lv_man_size = 30 * 5;
            }
            else
            {
                admin_vars.lv_man_size = 30 * admin_vars.sm_unm.size();
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
                                    text: bind admin_vars.sm_unm[listCell.index]
                                    visible: bind not listCell.empty and not admin_vars.lv_man_flag or not listCell.selected or (admin_vars.lv_man_ind != listCell.index)
                                }                                
                            ]
                        }
                         VBox {
							layoutInfo: LayoutInfo{width: 150}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind admin_vars.sm_name[listCell.index]
                                    visible: bind not listCell.empty and not admin_vars.lv_man_flag or not listCell.selected or (admin_vars.lv_man_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 110}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind admin_vars.sm_bdate[listCell.index]
                                    visible: bind not listCell.empty and not admin_vars.lv_man_flag or not listCell.selected or (admin_vars.lv_man_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 50}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind admin_vars.sm_dept[listCell.index]
                                    visible: bind not listCell.empty and not admin_vars.lv_man_flag or not listCell.selected or (admin_vars.lv_man_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 100}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind admin_vars.sm_phoneno[listCell.index]
                                    visible: bind not listCell.empty and not admin_vars.lv_man_flag or not listCell.selected or (admin_vars.lv_man_ind != listCell.index)
                                }                  
                            ]
                        }
						VBox {
							layoutInfo: LayoutInfo{width: 160}
                            spacing: 10
                            content: [
                                Label {
									id: "lbl"
                                    text: bind admin_vars.sm_email[listCell.index]
                                    visible: bind not listCell.empty and not admin_vars.lv_man_flag or not listCell.selected or (admin_vars.lv_man_ind != listCell.index)
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
                                    visible: bind not listCell.empty and (not admin_vars.lv_man_flag or not listCell.selected or (admin_vars.lv_man_ind != listCell.index))
                                    action: function() {
                                        admin_vars.cs = admin_vars.cn.prepareCall("call delete_manager(?)");
                                        admin_vars.cs.setString(1,'{admin_vars.sm_unm[listCell.index]}');
                                        admin_vars.cs.executeUpdate();
                                        delete admin_vars.sm_unm[listCell.index] from admin_vars.sm_unm;
                                        delete admin_vars.sm_name[listCell.index] from admin_vars.sm_name;
										delete admin_vars.sm_bdate[listCell.index] from admin_vars.sm_bdate;
										admin_vars.sm_dept[listCell.index] = "";
                                        delete "" from admin_vars.sm_dept;
										delete admin_vars.sm_phoneno[listCell.index] from admin_vars.sm_phoneno;
                                        delete admin_vars.sm_email[listCell.index] from admin_vars.sm_email;
										admin_vars.lv_man_size = 30 * admin_vars.sm_unm.size();
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
	
admin_vars.admin_view_manager = Panel
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
                    text: "Managers";
                    layoutX: 320;
                    layoutY: 40;
                    font:Font.font("ARIAL", FontWeight.BOLD, 20);
					effect:Glow {level:0.5};
                }
				Label
				{
					text: "You have not added any managers yet.";
                    layoutX: 220;
                    layoutY: 150;
                    font:Font.font("CALIBRI", FontWeight.BOLD, 20);
					textFill: Color.RED;
					visible: bind (admin_vars.viewManagerListView.height == 0)
				}
				ListView
				{
					layoutInfo: LayoutInfo{width: 750 height: 30}
					layoutX: 20
					layoutY: 100
					visible: bind not (admin_vars.viewManagerListView.height == 0)
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
											visible: bind not (admin_vars.viewManagerListView.height == 0)
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
											visible: bind not (admin_vars.viewManagerListView.height == 0)
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
											visible: bind not (admin_vars.viewManagerListView.height == 0)
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
											visible: bind not (admin_vars.viewManagerListView.height == 0)
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
											visible: bind not (admin_vars.viewManagerListView.height == 0)
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
											visible: bind not (admin_vars.viewManagerListView.height == 0)
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
											visible: bind not (admin_vars.viewManagerListView.height == 0)
										}
									]
									}
								]
							}
						}
					}
				}
				admin_vars.viewManagerListView,
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
            admin_vars.admin,
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
			
            admin_vars.main_side_panel,
			img1,img2,
        ]
    }
// Admin scene

var adminscene = Scene {
		fill: Color.LAVENDERBLUSH;				
		stylesheets: ["{__DIR__}sams.css"]
        content: [
            admin_vars.admin_add_department,admin_vars.admin_add_designation,admin_vars.admin_add_manager,admin_vars.admin_view_department,admin_vars.scrollbar,admin_vars.admin_addProduct,
			admin_vars.admin_afterlogin,admin_vars.admin_view_designation,admin_vars.admin_view_product,admin_vars.admin_view_manager,
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
			
            admin_vars.admin_side_panel,
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