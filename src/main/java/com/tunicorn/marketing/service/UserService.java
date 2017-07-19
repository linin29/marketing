package com.tunicorn.marketing.service;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.tunicorn.marketing.bo.UserBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.mapper.PrivilegeMapper;
import com.tunicorn.marketing.mapper.UserMapper;
import com.tunicorn.marketing.mapper.UserRoleMapper;
import com.tunicorn.marketing.vo.PrivilegeVO;
import com.tunicorn.marketing.vo.UserRoleVO;
import com.tunicorn.marketing.vo.UserVO;
import com.tunicorn.util.SecurityUtils;

@Service
public class UserService {
	@Autowired
	private UserMapper userMapper;
	@Autowired
	private PrivilegeMapper privilegeMapper;
	@Autowired
	private UserRoleMapper userRoleMapper;

	private final static int PAGE_SIZE = 10;

	public UserVO getUserByUserName(String userName) {
		return userMapper.getUserByUserName(userName);
	}

	public UserVO getUserByID(String userId) {
		return userMapper.getUserByID(userId);
	}

	/**
	 * 从DB取当前登录的用户信息，因为可能有多个信息可以用来登录，所有需要多次尝试。以后若增加新的可以用来登录的信息，需要相应的修改该方法。 1.
	 * Use user name 2. Use email 3. Use xx
	 * 
	 * @param userName
	 * @return
	 */
	public UserVO getLoginUser(String userName) {
		UserVO user = getUserByUserName(userName);
		if (user == null) {
			// user = getUserByEmail(userName);
		}
		return user;
	}

	public List<PrivilegeVO> getMenuPrivileges(String userId) {
		return privilegeMapper.getMenuPrivileges(userId);
	}

	/**
	 * verify password
	 * 
	 * @param dbUser
	 * @param password
	 * @return
	 */
	public boolean isValidUser(UserVO dbUser, String password) {
		boolean isValid = false;
		if (dbUser != null && SecurityUtils.verifyPassword(password, dbUser.getPassword())) {
			isValid = true;
		}
		return isValid;
	}

	public long getTotalPage(long totalTrack) {
		if (totalTrack % PAGE_SIZE == 0) {
			return totalTrack / PAGE_SIZE;
		} else {
			return totalTrack / PAGE_SIZE + 1;
		}
	}

	/**
	 * update user password
	 * 
	 * @param user
	 * @return
	 */
	public boolean updatePassword(UserVO user) {
		String newPassword = SecurityUtils.generateHashPassword(user.getNewPassword());
		user.setPassword(newPassword);
		return userMapper.updateUserPassword(user);
	}

	public Boolean deleteUser(String userId) {
		return userMapper.deleteUser(userId);
	}

	public int createUser(UserVO userVO) {
		userVO.setId((Long.toHexString(new Date().getTime()) + RandomStringUtils.randomAlphanumeric(13)).toLowerCase());
		userVO.setPassword(SecurityUtils.generateHashPassword(MarketingConstants.TIANNUO_PASSWORD));
		return userMapper.createUser(userVO);
	}

	@Transactional
	public int createUserWithRoleMapping(UserVO userVO) {
		userVO.setId((Long.toHexString(new Date().getTime()) + RandomStringUtils.randomAlphanumeric(13)).toLowerCase());
		userVO.setPassword(SecurityUtils.generateHashPassword(MarketingConstants.TIANNUO_PASSWORD));
		int result = userMapper.createUser(userVO);
		UserRoleVO userRole = new UserRoleVO();
		userRole.setUserId(userVO.getId());
		userRole.setRoleId(1);
		userRoleMapper.createUserRoleMapping(userRole);
		return result;
	}

	public List<UserVO> getUserListByBO(UserBO userBO) {
		return userMapper.getUserListByBO(userBO);
	}

	public int getUserCount(UserBO userBO) {
		return userMapper.getUserCount(userBO);
	}

	public int updateUser(UserVO userVO) {
		return userMapper.updateUser(userVO);
	}
}
