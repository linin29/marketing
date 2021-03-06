package com.tunicorn.marketing.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.tunicorn.marketing.entity.Menu;
import com.tunicorn.marketing.service.UserService;
import com.tunicorn.marketing.vo.PrivilegeVO;
import com.tunicorn.marketing.vo.UserVO;

@Controller
@EnableAutoConfiguration
@RequestMapping("/dashboard")
public class HomeController extends BaseController {

	@Autowired
	private UserService userService;

	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String homepage(HttpServletRequest request, HttpServletResponse resp, Model model) {
		UserVO user = getCurrentUser(request);
		List<PrivilegeVO> privilegeList = userService.getMenuPrivileges(user.getId());
		List<Menu> menuList = generateMenuList(privilegeList);
		model.addAttribute("user", user);
		model.addAttribute("menus", menuList);
		return "dashboard/main";
	}

	private List<Menu> generateMenuList(List<PrivilegeVO> privilegeList) {
		List<Menu> result = new ArrayList<Menu>();

		if (privilegeList == null || privilegeList.size() == 0) {
			return result;
		}

		Map<Long, Menu> mapping = new HashMap<Long, Menu>();
		for (PrivilegeVO privilege : privilegeList) {
			Menu menu = new Menu();
			menu.setName(privilege.getPrivilegeName());
			menu.setUrl(privilege.getPrivilegeValue());
			menu.setOrder(privilege.getDisplayOrder());

			mapping.put(privilege.getId(), menu);
		}

		for (PrivilegeVO privilege : privilegeList) {
			if (privilege.getParentId() != 0) {
				Menu parentMenu = mapping.get(privilege.getParentId());
				if (!parentMenu.getSubMenus().contains(mapping.get(privilege.getId()))) {
					parentMenu.getSubMenus().add(mapping.get(privilege.getId()));
				}
			} else {
				Menu targetMenu = mapping.get(privilege.getId());
				if (!result.contains(targetMenu)) {
					result.add(targetMenu);
				}
			}
		}

		return result;
	}
}
