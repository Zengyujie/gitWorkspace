<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<%-- 
jsp的本质是servlet

当第一次访问jsp页面的时候，tomcat会把jsp页面翻译成一个java源文件
，并且将它编译成为.class字节码程序。

源文件的类容是一个HttpJspBase的子类，该类直接继承了HttpServlet类

jsp头部的page指令：

1，language： 表示jsp翻译后支持什么语言，目前支支持java
2，contentType: jsp返回的数据类型是什么
3, pageEncoding: 当前jsp本身的字符集
4, import: 和java中一样
------以下两个属性给out输出流使用
5, autoFlush:设置当out输出流缓冲区满了后，是否默认刷新，默认true
6, buffer:设置out缓冲区大小，默认8k

7, errorPage: 错误跳转路径，一般以/开头，映射到代码的web目录（因为解析成的servlet在路径）
8, isErrorPage:设置当前是否为错误页面，默认false，如果设置为true，可以获取错误信息
9, session:设置访问当前页面是否会创建HttpSession对象，默认true
10,extends: 设置jsp翻译出的java类，默认继承谁


jsp中常见脚本：

1，声明脚本：
	/</%! 声明Java代码 / %/>
	可以生成java代码
	
2，表达式脚本：
	/</%=   %/>
	作用是在jsp页面上输出数据，特点是：所有的表达式脚本都会被翻译到_jspService方法中，
	所有的表达式脚本都会被翻译到out.print(obj)输出到页面上。
	_jspService方法中的对象都可以直接使用。表达式脚本结尾不能加分号

3，代码脚本：
	/</% 代码  /%/>
	作用是编写Java代码实现功能。其实就是插入在生成的servlet中的若干out.write函数
	中间。同上，可以调用_jspService方法中的对象。可以由多个脚本组合完成一个Java语句
	可以和表达式脚本结合使用

jsp三大注释：html，java(在代码脚本中)，jsp注释(可以注释掉一切)
	/</%-- /--/%/>


jsp中的九大内置对象，jsp翻译为servlet代码后得到的内置对象
1,request：请求对象
2,response：响应对象
3,pageContext：jsp上下文对象
4,session：会话对象
5,application：servletContext对象
6,config：servletConfig对象
7,out：jsp输出流对象
8,page：只想当前jsp页面的对象
9,exception:异常对象

四大域对象：
1，pageContext(PageContextImpl类) ：当前jsp范围有效
2，Request(HttpServletRequest类)：一次请求有效
3，Session(HttpSession类)：一个会话范围有效（打开浏览器，直到关闭浏览器）
4，Application(ServletContext类)：只要web服务器不关闭都有效
四个域都可以存取数据，他们的优先级分别是从小到大的范围顺序，为了减轻内存的压力


response.getWriter 和jsp中out的区别：
俩个流的缓冲区不同，都是输出到各自的缓冲区，当jsp页面中所有页面执行完毕后会执行
以下两种操作：1，执行out.flush()，会把out缓冲区的数据追加到response缓冲区末尾
2，会执行response的刷新操作，把所有数据传给客户端。
由于jsp翻译后都是用out输出，所以一般情况下，jsp中统一使用out输出，避免打乱
输出顺序
out.write()输出字符串没有问题(整性可能的问题是，底层将int强转为字符串了)
out.print()输出任何数据都没有问题，因为都是将他们转为字符串再write
因此在jsp页面中，一般使用out.print()


JSP常用标签：

(网页分割，改一个该所有)
1，静态包含(最常用，因为jsp逐渐只负责输出数据了，不会有很多复杂的调用)
	<%@ include file="/test/foot.jsp"%>:file属性就是静态包含
	地址中第一个/表示工程路径的目录
	1，静态包含不会翻译包含jsp成servlet
	2，静态包含其实就是把包含的jsp页面代码拷贝到包含位置输出
2，动态包含
	<jsp:include page="/test/foot.jsp"></jsp:include>
	1，动态包含会把包含的jsp页面翻译成java代码
	2，动态包含底层代码使用代码调用被包含的jsp输出，底层是主jsp把自己的request，response，out都
	传递给被包含的jsp去使用了
	3，动态包含还可以传递参数
	<jsp:include page="/test/foot.jsp">
		<jsp:param name="username" value="zhangsan"/>
	</jsp:include>
3，请求转发
	<jsp:forward page="转发路径">
		<!--可带参数，同上 -->
	</jsp:forward>
	
 --%>

<%@ page import="java.util.*" %>

<%! 
	private String objId;
	private static ArrayList<Integer> list = null;
	static{
		list = new ArrayList<>();
		list.add(12);
	}
	
	public int abc(){
		return 12;
	}
%>


<%=12 %>
<%= list.get(0) %>
<%= request.getAttribute("username") %>


<%
	int i = 12;
	if(i == 12){
		System.out.println(i);
	}

%>

<%

for(int j = 0; j < 10; j++){

%>
<p>this is a paragraph</p>
<%= i++ %>
<%
	System.out.println(i);
}
%>

</body>
</html>
