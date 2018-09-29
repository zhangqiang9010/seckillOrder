<!DOCTYPE html>
<html lang="java">
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>秒杀详情页</title>

    <%@include file="common/head.jsp"%>
</head>
<body>
   <div class="container">
       <div class="panel panel-default text-center">
           <div class="panel-heading">
               <h1>${seckill.name}</h1>
           </div>
           <div class="panel-body">
               <h2 class="text-danger">
                   <%--显示time图标--%>
                   <span class="glyphicon glyphicon-time"></span>
                   <%--展示倒计时--%>
                   <span class="glyphicon" id="seckill-box"></span>
               </h2>

           </div>
       </div>
   </div>
   <%--登录弹出层，输入电话--%>
   <div id="killPhoneModal" class="modal fade">
       <div class="modal-dialog">
           <div class="modal-content">
               <div class="modal-header">
                   <h3 class="modal-title text-center">
                       <span class="glyphicon glyphicon-phone"></span>
                   </h3>
               </div>
               <div class="modal-body">
                   <div class="row">
                       <div class="col-xs-8 col-xs-offset2">
                           <input type="text" name="killPhone" id="killPhoneKey"
                                placeholder="填手机号哦" class="form-control"/>
                       </div>
                   </div>
               </div>
               <div class="modal-footer">
                   <%--验证信息--%>
                   <span id="killPhoneMessage" class="glyphicon"></span>
                   <button type="button" id="killPhoneBtn" class="btn btn-success">
                       <span class="glyphicon glyphicon-phone"></span>
                       Submit
                   </button>
               </div>
           </div>
       </div>
   </div>
   <!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
   <script src="https://apps.bdimg.com/libs/jquery/2.0.0/jquery.min.js"></script>

   <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
   <script src="https://apps.bdimg.com/libs/bootstrap/3.3.0/js/bootstrap.min.js"></script>

   <%--jquery cookie操作插件--%>
   <%--使用cdn获取公共js http://www.bootcdn.cn/--%>
   <script src="https://cdn.bootcss.com/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
   <%--jQuery countDown倒计时插件--%>
   <script src="https://cdn.bootcss.com/jquery.countdown/2.1.0/jquery.countdown.min.js"></script>
   <%--开始编写交互逻辑--%>

   <script type="text/javascript">

       var seckill = {
           //封装秒杀相关ajax的url
           URL:{
               now : function () {
                   return '/seckill/time/now';
               },
               exposer : function (seckillId) {
                   return '/seckill/'+seckillId +'//exposer';
               },
               execution: function (seckillId,md5) {
                   return '/seckill/'+seckillId+'/'+md5+'/execution';
               }
           },
           handleSeckillkill : function (seckillId,node) {
               //获取秒杀地址,控制显示逻辑，执行秒杀
               debugger;
               node.hide().html('<button class="btn btn-primary btn-lg" id="killBtn">开始秒杀</button>')
             $.post(seckill.URL.exposer(seckillId),{},function (result) {
                 //在回调函数中，执行交互流程
                 debugger;
                 if(result && result['success']){
                     var exposer = result['data'];
                     if(exposer['exposed']){
                         //开启秒杀
                         //获取秒杀地址
                         var md5 = exposer['md5'];
                         var killUrl = seckill.URL.execution(seckillId,md5);
                         console.log("killUrl:"+killUrl);
                         //绑定一次点击事件
                         $('#killBtn').one('click',function () {
                             debugger;
                             //执行秒杀请求
                             $(this).addClass('disabled');
                             //发送秒杀请求
                             $.post(killUrl,{},function (result) {
                                 debugger;
                                 if(result && result['success']){
                                     var killResult = result['data'];
                                     var  state = killResult['state'];
                                     var stateInfo = killResult['stateInfo'];
                                     //显示秒杀结果
                                     node.html('<span class="label label-success">'+stateInfo+'</span>');
                                 }
                             });
                         });
                         node.show();
                     }else {
                         //未开启秒杀
                         var now = exposer['now'];
                         var start = exposer['start'];
                         var end = exposer['end'];
                         //重新计算计时逻辑
                         seckill.countdown(seckillId,now,start,end);
                     }
                 }else {
                     console.log('result:'+result)

                 }
             });
           },
           //验证手机号
           validatePhone:function (phone) {

               if(phone && phone.length == 11 && !isNaN(phone)){
                   return true;

               }else {
                   return false;
               }
           },
           countdown:function (seckillId,nowTime,startTime,endTime) {
               debugger;
              var seckillBox = $('#seckill-box');
               //时间判断
               if(nowTime>endTime){
                   //秒杀结束
                   seckillBox.html('秒杀结束!');
               }else if(nowTime < startTime){
                   //秒杀未开始
                   var killTime = new Date(startTime + 1000);

                   seckillBox.countdown(killTime,function (event) {
                       debugger;
                       var format = event.strftime('秒杀计时：%D天 %H时 %M分 %S秒');
                       seckillBox.html(format);
                       //时间完成后回调事件
                   }).on('finish.countdown',function () {
                       //获取秒杀地址,控制显示逻辑，执行秒杀
                       seckill.handleSeckillkill(seckillId,seckillBox);

                   });

               }else {
                   //秒杀开始
                   seckill.handleSeckillkill(seckillId,seckillBox);

               }
           },
           //详情页秒杀逻辑
           detail:{

               //详情页初始化
               init:function (params) {
                   //手机验证和登录,计时交互
                   //规划我们的交互流程
                   //在cookie中查找手机号
                   var killPhone = $.cookie('killPhone');

                   //验证手机号
                   if (!seckill.validatePhone(killPhone)){
                       //绑定phone
                       //控制输出
                       var killPhoneModal = $('#killPhoneModal');
                       //显示弹出层
                       killPhoneModal.modal({
                           show:true,//显示弹出层
                           backdrop:'static',//禁止位置关闭
                           keyboard:false//关闭键盘事件
                       });
                       $('#killPhoneBtn').click(function () {
                           debugger;
                           var inputPhone = $('#killPhoneKey').val();
                           console.log('inputPhone='+inputPhone);//TODO
                           if(seckill.validatePhone(inputPhone)){
                               //电话写入cookie
                               $.cookie('killPhone',inputPhone,{expires:7,path:'/seckill'});
                               //刷新页面
                               window.location.reload();
                           }else {
                               $('#killPhoneMessage').hide().html('<label class="label label-danger">手机号错误!</label>').show(300);

                           }


                       });
                   }

                   //已经登录，计时交互
                   var startTime = params['startTime'];
                   var endTime = params['endTime'];
                   var seckillId = params['seckillId'];
                   $.get('/seckill/time/now',{},function (result) {
                       debugger;
                       if (result && result['success']){
                           debugger;
                           var nowTime = result['data'];
                           //时间判断
                           seckill.countdown(seckillId,nowTime,startTime,endTime);

                       }else {
                           console.log('result:' +result);
                       }

                   });
               }
           }
       }

       $(function () {
           //使用EL表达式传入参数
           seckill.detail.init({
               seckillId:${seckill.seckillId},
               startTime:${seckill.startTime.time},//毫秒
               endTime:${seckill.endTime.time}
           });
       });
   </script>
</body>


</html>