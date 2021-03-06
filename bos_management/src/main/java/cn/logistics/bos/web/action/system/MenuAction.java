package cn.itcast.bos.web.action.system;

import java.util.List;

import org.apache.shiro.SecurityUtils;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.opensymphony.xwork2.ActionContext;

import cn.itcast.bos.domain.system.Menu;
import cn.itcast.bos.domain.system.User;
import cn.itcast.bos.service.system.MenuService;
import cn.itcast.bos.web.action.common.BaseAction;
//菜单action
@Controller
@Scope("prototype")
public class MenuAction extends BaseAction<Menu>{
	//注入service
	@Autowired
	private MenuService menuService;

	//列出所有菜单列表
	@Action("menu_list")
	public String list(){
		List<Menu> menuList= menuService.findMenuList();
		ActionContext.getContext().getValueStack().push(menuList);
		return JSON;
	}
	
	//添加菜单
	@Action(value="menu_add",results={
			@Result(type=REDIRECT,location="/pages/system/menu.html")
	})
	public String add(){
		menuService.saveMenu(model);
		return SUCCESS;
	}
	
	//根据用户列出菜单
	@Action("menu_listByUser")
	public String listByUser(){
		//获取当前登录用户
		User user=(User)SecurityUtils.getSubject().getPrincipal();
		//调用业务层
		List<Menu> menuList= menuService.findMenuListByUser(user);
		ActionContext.getContext().getValueStack().push(menuList);
		
		return JSON;
	}
}
