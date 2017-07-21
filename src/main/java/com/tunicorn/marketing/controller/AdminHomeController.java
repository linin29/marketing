package com.tunicorn.marketing.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.tunicorn.marketing.entity.Menu;
import com.tunicorn.marketing.service.AdminUserService;
import com.tunicorn.marketing.vo.AdminUserVO;
import com.tunicorn.marketing.vo.PrivilegeVO;

@Controller
@EnableAutoConfiguration
@RequestMapping("/admin/dashboard")
public class AdminHomeController extends BaseController {

	@Autowired
	private AdminUserService adminUserService;

	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String homepage(HttpServletRequest request, HttpServletResponse resp, Model model) {
		AdminUserVO user = getCurrentAdminUser(request);
		List<PrivilegeVO> privilegeList = adminUserService.getMenuPrivileges(String.valueOf(user.getId()));
		List<Menu> menuList = generateMenuList(privilegeList);
		String indexUrl = "";
		if (menuList != null && menuList.size() > 0) {
			Menu menu = menuList.get(0);
			List<Menu> subMenus = menu.getSubMenus();
			if (StringUtils.isNotBlank(menu.getUrl())) {
				indexUrl = menu.getUrl();
			} else if (subMenus != null && subMenus.size() > 0) {
				indexUrl = subMenus.get(0).getUrl();
			}
		}
		model.addAttribute("indexUrl", indexUrl);
		model.addAttribute("user", user);
		model.addAttribute("menus", menuList);
		return "admin/dashboard/main";
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
