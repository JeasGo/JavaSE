package cn.itcast.bos.web.action;

import javax.ws.rs.core.MediaType;

import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.client.WebClient;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.itcast.bos.domain.base.Area;
import cn.itcast.bos.domain.take_delivery.Order;
import cn.itcast.bos.utils.Constants;
import cn.itcast.bos.web.action.common.BaseAction;

//前台订单action
@Controller
@Scope("prototype")
public class OrderAction extends BaseAction<Order> {
	// 属性驱动接收区域
	private String sendAreaInfo;
	private String recAreaInfo;

	public void setSendAreaInfo(String sendAreaInfo) {
		this.sendAreaInfo = sendAreaInfo;
	}

	public void setRecAreaInfo(String recAreaInfo) {
		this.recAreaInfo = recAreaInfo;
	}

	@Action(value = "order_add", results = { 
			@Result(type = REDIRECT, location = "/index.html#/order.html") 
			})
	public String add() {

		// 目标：重新组装区域（江苏省/常州市/溧阳市）
		// 寄件区域
		String[] sendAreaArray = StringUtils.split(sendAreaInfo, "/");
		Area sendArea = new Area();
		sendArea.setProvince(sendAreaArray[0]);
		sendArea.setCity(sendAreaArray[1]);
		sendArea.setDistrict(sendAreaArray[2]);
		// 收件区域
		String[] recAreaArray = StringUtils.split(recAreaInfo, "/");
		Area recArea = new Area();
		recArea.setProvince(recAreaArray[0]);
		recArea.setCity(recAreaArray[1]);
		recArea.setDistrict(recAreaArray[2]);

		// 将数据封装到model
		model.setSendArea(sendArea);
		model.setRecArea(recArea);
		// 调用bos的webserivce
		WebClient.create(Constants.BOS_MANAGEMENT_URL+"/services/orderservice/orders")
		.type(MediaType.APPLICATION_JSON)
		.post(model);

		return SUCCESS;
	}
}
