<!DOCTYPE html>
<html lang="java">
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>秒杀列表页</title>
    <%--引入jstl--%>
    <%@include file="common/head.jsp"%>
    <%@include file="common/tag.jsp"%>

</head>
<body>
   <%--页面显示部分--%>
    <div class="container">
        <div class="panel panel-default">
            <h2>秒杀列表</h2>
        </div>
        <div class="panel-body">
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>名称</th>
                    <th>库存</th>
                    <th>开始时间</th>
                    <th>结束时间</th>
                    <th>创建时间</th>
                    <th>详情页</th>

                </tr>
                </thead>
                <tbody>
                   <c:forEach var="sk" items="${list}">
                       <tr>
                           <td>${sk.name}</td>
                           <td>${sk.number}</td>
                           <td>
                               <fmt:formatDate value="${sk.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                           </td>
                           <td>
                               <fmt:formatDate value="${sk.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                           </td>
                           <td>
                               <fmt:formatDate value="${sk.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                           </td>
                           <td>
                               <a class="btn btn-info" href="/seckill/${sk.seckillId}/detail" target="_blank">link</a>
                           </td>

                       </tr>
                   </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</body>
<!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
<script src="https://apps.bdimg.com/libs/jquery/2.0.0/jquery.min.js"></script>
<!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
<script src="https://apps.bdimg.com/libs/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</html>