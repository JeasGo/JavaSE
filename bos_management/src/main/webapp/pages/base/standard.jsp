<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 引入shiro的标签库 -->
<%@taglib uri="http://shiro.apache.org/tags"  prefix="shiro"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
		<meta charset="UTF-8">
		<title>取派标准</title>
		<!-- 导入jquery核心类库 -->
		<script type="text/javascript" src="../../js/jquery-1.8.3.js"></script>
		<!-- 导入easyui类库 -->
		<link rel="stylesheet" type="text/css" href="../../js/easyui/themes/default/easyui.css">
		<link rel="stylesheet" type="text/css" href="../../js/easyui/themes/icon.css">
		<link rel="stylesheet" type="text/css" href="../../js/easyui/ext/portal.css">
		<link rel="stylesheet" type="text/css" href="../../css/default.css">
		<script type="text/javascript" src="../../js/easyui/jquery.easyui.min.js"></script>
		<script type="text/javascript" src="../../js/easyui/ext/jquery.portal.js"></script>
		<script type="text/javascript" src="../../js/easyui/ext/jquery.cookie.js"></script>
		<script src="../../js/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
		<script type="text/javascript">
			$(function(){
				// 先将body隐藏，再显示，不会出现页面刷新效果
				$("body").css({visibility:"visible"});
				
				// 收派标准信息表格
				$('#grid').datagrid( {
					iconCls : 'icon-forward',
					fit : true,
					border : false,
					rownumbers : true,
					striped : true,
					//pageList: [30,50,100],
					pageList: [2,20,200],
					pagination : true,
					toolbar : toolbar,
					//请求数据的地址
					//url : "../../data/standard.json",
					url : "../../standard_listPage.action",
					idField : 'id',
					columns : columns
				});
				
				
				//保存事件
				$("#save").click(function(){
					//表单校验
					if($("#standardForm").form("validate")){
						//校验通过，提交表单
						$("#standardForm").submit();
					}
				});
				
				
				//给添加或修改窗口绑定关闭事件
				$("#standardWindow").window({
					onClose:function(){
						//alert(1);
						//目标：清空表单
						//reset无法重置隐藏域
						$("#standardForm")[0].reset();
						//手动清除隐藏域
						$("input[name='id']").val("");
						//$("#standardForm").form("clear");
					}
				});
			});	
			
			//工具栏
			var toolbar = [ {
				id : 'button-add',
				text : '增加',
				iconCls : 'icon-add',
				handler : function(){
					//alert('增加');
					//弹出添加表单窗口
					$("#standardWindow").window("open");
					
				}
			}, {
				id : 'button-edit',
				text : '修改',
				iconCls : 'icon-edit',
				handler : function(){
					//alert('修改');
					//第一步：判断用户是否选择了才能弹出修改框
					//获取选中的行
					var rows=$("#grid").datagrid("getSelections");
					//判断
					if(rows.length!=1){
						$.messager.alert("提示","请只能选择一条记录","info");
						return;
					}
					
					//第二步：填充修改框的表单
					$("#standardForm").form("load",rows[0]);
					
					//第三步：弹出修改框
					$("#standardWindow").window("open");
					
					
				}
			},
			<shiro:hasPermission name="courier:delete">
			{
				id : 'button-delete',
				text : '作废',
				iconCls : 'icon-cancel',
				handler : function(){
					alert('作废');
				}
			},
			</shiro:hasPermission>
			{
				id : 'button-restore',
				text : '还原',
				iconCls : 'icon-save',
				handler : function(){
					alert('还原');
				}
			}];
			
			// 定义列
			var columns = [ [ {
				field : 'id',
				checkbox : true
			},{
				field : 'name',
				title : '标准名称',
				width : 120,
				align : 'center'
			}, {
				field : 'minWeight',
				title : '最小重量',
				width : 120,
				align : 'center'
			}, {
				field : 'maxWeight',
				title : '最大重量',
				width : 120,
				align : 'center'
			}, {
				field : 'minLength',
				title : '最小长度',
				width : 120,
				align : 'center'
			}, {
				field : 'maxLength',
				title : '最大长度',
				width : 120,
				align : 'center'
			}, {
				field : 'operator',
				title : '操作人',
				width : 120,
				align : 'center'
			}, {
				field : 'operatingTime',
				title : '操作时间',
				width : 120,
				align : 'center'
			}, {
				field : 'company',
				title : '操作单位',
				width : 120,
				align : 'center'
			} ] ];
		</script>
	</head>

	<body class="easyui-layout" style="visibility:hidden;">
		<div region="center" border="false">
			<%-- <shiro:hasRole name="base">
				<input/>
			</shiro:hasRole> --%>
			当前登录用户是：<shiro:principal property="username"></shiro:principal>
			
			<table id="grid"></table>
		</div>
		
		<div class="easyui-window" title="对收派标准进行添加或者修改" id="standardWindow" collapsible="false" minimizable="false" maximizable="false" modal="true" closed="true" style="width:600px;top:50px;left:200px">
			<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
				<div class="datagrid-toolbar">
					<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
				</div>
			</div>

			<div region="center" style="overflow:auto;padding:5px;" border="false">
				
				<form id="standardForm" action="../../standard_add.action" method="post">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">收派标准信息
								<!--提供隐藏域 装载id -->
								<input type="hidden" name="id" />
							</td>
						</tr>
						<tr>
							<td>收派标准名称</td>
							<td>
								<input type="text" name="name" 
									class="easyui-validatebox" data-options="required:true" />
							</td>
						</tr>
						<tr>
							<td>最小重量</td>
							<td>
								<input type="text" name="minWeight" 
										class="easyui-numberbox" required="true" />
							</td>
						</tr>
						<tr>
							<td>最大重量</td>
							<td>
								<input type="text" name="maxWeight" class="easyui-numberbox" required="true" />
							</td>
						</tr>
						<tr>
							<td>最小长度</td>
							<td>
								<input type="text" name="minLength" class="easyui-numberbox" required="true" />
							</td>
						</tr>
						<tr>
							<td>最大长度</td>
							<td>
								<input type="text" name="maxLength" class="easyui-numberbox" required="true" />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</body>

</html>