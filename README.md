#版本控制工具
分布式：git  
集中式：SVN  
优点：代码存在单一服务器上，便于管理  
缺点：单点故障  

#1，初始化
	git config --global user.name "myname"
	git config --global user.email myemail@qq.com  
	--global表示全局性操作，--system表示只针对当前系统，不写表示针对当前项目(当前文件夹)  
	设置完之后查看  git config --list


#2，基本概念：
	1.区域：
		1，工作区：本地代码(沙箱环境)
			|
			|  提交
			V
		2，暂存区：
			|
			|  提交
			V
		3，版本库：
	2.对象：
		1.Git对象：单个文件的一次提交
		2.树对象：项目的一次提交

		3.提交对象：项目的一个版本，对树对象的封装，提供了注释等，并且按顺序将提交对象串联起来

	3.git存的不是增量，是每次提交的快照

#3，windows上git可用的linux基本命令： 
 
	clear：清屏  
	echo “info”控制台输出  
	ll：子目录平铺在控制台  
	find 目录名  
	find 目录名 -type f:只找文件
	rm 文件名
	mv 源文件 重命名文件(可以带路径)
	cat 文件url
	vim 启动vim

#4，git基本命令：
	1，git init：在目录下使用，就会将当前目录创建为仓库

#5，git目录：
	hooks：包含客户端或服务端的钩子脚本(回调函数)，提交前后过程中都可以添加操作
	info：包含一个全局性排除文件，即不需要git维护的数据
	logs：保存日志
	objects：目录存储所有数据内容(重要)
	refs目录存储只想数据(分支)的提交对象指针(重要)
	config：文件包含项目特有的配置选项
	description：仓库的描述信息
	HEAD：文件指示目前被捡出的分支(重要)
	index：文件曹村暂存区信息(重要)

#6，git对象：
	git核心是一个键值对数据库，可以根据键入内容获取值
	
	1，键值对测试：
		1，echo 'test' | git hash-object -w --stdin
		:含义，hash-object：命令存储数据对象'test'，若不加w则只返回值，不存储，后面的--stdin表示内容的输入为标准输入流(前面的'test')，如果接文件路径就会将对应文件做hash  
		2，git cat-file -p hashvalue 就能看到hashvalue对应的值'test', -p表示显示内容 -t表示返回内容的类型(blob)  
	2，git对象只能存文件的内容，甚至没有文件名，只能通过hash获取，因此并不代表项目的版本，项目的一个版本可能包含很对个对象的修改
	3，git对象的问题：
		1，通过hash值取文件内容不方便
		2，文件名没有被保存



#7，树对象：  
	1，解决文件名保存的内容，允许多个文件组织到一起，一个树对象包含了一条或多条记录，也可以包含树对象
	2，如何生成树对象：
		1，首先更新git对象：git update-info --add --cacheinfo 文件格式 hash值 文件名
		eg：git update-index --add --cacheinfo 100644 560a3d89bf36ea10794402f6664740c284d4ae3bte test.txt
		如果不是第一此添加不用加--add

		2，git write-tree完成树的创建

		3，将两个树合并到一起：
		git read-tree --prefix=bak hash
		eg: git read-tree --prefix=bak 06e21bb0105e2de6c846725a9a7172f57dd1af96
		读取第一棵树到暂存区

		然后git write-tree

	3，查看暂存区内容
	git ls-files -s


#8，提交对象：
	1，通过commit-tree命令创建一个提交对象，需要提供hash值和父对象(第一次不用)
	git commit-tree hash
	eg: echo "first commit" | git commit-tree 9f52602d4bbf79505f33886f7a879b5497f87693
	echo内容相当于添加注释
	第二个提交对象：
	git commit-tree 这次提交树的hash -p 父树的hash

#9，git add操作的流程：先在版本库中生成git对象，然后再将其拿到暂存区。并不是工作目录直接到暂存区。
	在提交的时候，再参照暂存区生成树对象，然后放到版本库，然后
    从版本库将树对象取出添加注释信息生成提交对象，然后放入版本
    库中，因此一次提交只能有一个树对象，提交对象。

#10，git操作最基本流程：
	1，创建工作目录，进行操作
		git init
	2，执行git add./
		1，git hash-object -w 文件名：修改了多少工作目录中的文件，此命令就被执行多少次
		2，git update-index ...：
	3，执行git commit -m “注释内容”
		git write-tree
		git commit-tree

#11，工作目录下文件的两种状态：
	1，已跟踪(已提交、已修改、已暂存的文件)
	2，未跟踪(未纳入版本管理的文件)

	3，初次克隆的仓库所欲文件都属于已跟踪文件

	文件状态生命周期：
	| -----未跟踪-------| -------------------已跟踪------------------|                       
	untracked          unmodified           modified           staged(暂存区)
	    |                  |                   |                    |
	    | -> add file ->   |  -> edit file ->  |                    |
	    |                  |                   |                    |
	    |                  |                   | -> stage file ->   |
	    |<- remove file <- |                   |                    |
	    |                  | <---------- commit  ----------------   |

#12，查看当前工作环境提交状态
	git status
	文件已经暂存：绿色
	暂存区文件已经修改：红色(需要重新add)
	文件已提交：没有信息


#13，查看当前已跟踪文件的那些修改还没有暂存
	git diff
	查看暂存区中哪些更新已经暂存起来准备好下次提交
	git diff --cached 或者 --staged(1.6.1版本以上)

#14，暂存加提交的操作
	git commit -a (-m “注释”)：只有跟踪过的文件才可以使用-a，否则需要先手动add一次
	等价于git add./ + git commit

#15，删除操作
	1，文件本地rm之后重新add./ 然后提交
	2，git rm 文件名，然后git commit

#16，改名相当于先删除一个文件，再创建一个文件
    git mv 原名字 新名字/。 然后提交

#17，git日志操作：查看版本修改信息
	git log
	git log --oneline ：一行显示
	git log --pretty=oneline：同样的作用


///////////分支///////////////



#18，分支是一个指向提交对象的可变指针
	分支实体存在refs的heads文件夹中，是以分支名命名的文件，文件中储存提交对象的hash值

	可变指针存在HEAD文件中，内容是refs/heads/当前分支名

#19，创建分支：
	1，git branch 分支名字
	创建之后并不会直接切换到新的分支中去
	2，git branch 不加参数等于显示当前分支列表
	3，git branch 自己命名 历史的提交对象：在那个历史对象处创建分支，实现时光穿梭


#20，切换分支
	1，git checkout 分支 要指向的提交对象
	2，git checkout -b 分支名：创建分支并且切换过去

	在新版git中，为了避免checkout --file的语义区别，新增了切换命令
	git switch -c 分支名：创建并切换到该分支
	git swtich 分支名：切换分支


#21，删除分支
	git branch -d 分支名字：删除已经被合并的分支
	不能自己删除自己

	git branch -D 分支名字：强制删除分支，就算没有合并也可以删除

#22，查看项目的分支历史
	git log --oneline --decorate --graph --all


#23，为命令配别名
    1.git config --global alias.别名 要改成别名的命令(双引号建议加上)  
	git config --global alias.co checkout
	这样git checkout = git co
	注意alias


#24，查看当前分支的最后一次提交
	git branch -v

#25，注意：
    
    1.分支切换会改变工作目录中的文件，在切换分支时，如果切换的是一个旧的分支，工作目录会恢复到该分支最后一次提交时的样子，如果git不能干净利落地完成这个任务，它将禁止切换分支，即在每次切换分支前，需要交当前分支：
	
	2.建议在每次切换前使用git status查看当前提交情况，如果没有提交就commit，然后再切换分支

	3.切换分支会改变三个地发：HEAD指针，暂存区，工作目录

	4.如果分支中有未被跟踪的修改，或有未提交的暂存，那么切换到其他分支时，该这些文件会被保留，这样会污染其他分支，建议不要这么做

	5.如果当前分支提交过，如果有未提交的修改，那么将无法提交

	6.如果分支1上有未被跟踪的文件，然后再切换时传入了分支2，然后分支2没有处理这些文件，又切回了分支一，此时如果切回分支2，将看不到之前分支1带来的那些文件


#26，开发时的流程：
	1，遇到新的需求首先在线上分支上创建一个分支
	2，在新的分支上开展工作
	3，测试通过后回到线上分支，将自己修改的分支和线上分支合并，然后将合并的分支推到线上分支
	4，删除新的分支
	5，切换回自己的分支继续工作

	一切以主分支为基点

#27，分支合并
	1，git merge 要合并的分支：要合并的分支和当前分支合并

	2，如果修改的分支是在主分支基础上修改的，则合并成为快进(fast-forward)合并，可以使用参数--no-ff禁止快进合并

	快进合并不会产生冲突

	合并之后就可以使用git branch -d 删除修改的分支了

	3，典型合并：分支1对文件1做了修改并提交，分支2也对文件做了修改并提交，在合并两个分支时，文件1会留存两个分支的修改，需要手动对文件1修改，然后提交，并删除多余分支


/////////////////存储///////////////

#28，栈
	
	当前项目已经进行一段时间后，所有东西进入混乱的状态，此时需要切换到另一个分支做一些事情，问题是，目前不想为当前内容做一次提交，解决方法是：git stash命令
	
    git stash将未完成的修改保存到一个栈上，在任何时候可以重新应用这些改动(git stash apply)

	git stash list：查看存储
	git stash apply stash名字：如果不指定名字，git获取最近的存储
	git stash pop： 应用储藏，并在栈中删除
	git stash drop stash名字：删除名字的存藏

	在主分支上修改后，如果仅仅想同步修改，不想全部merge，可以使用
	git cherry-pick 主分支提交的hash值
	将修改复制到当前分支(本质上还是重新提交了一次)

//////////////后悔药//////////////

#29，三种情况：
	1，工作区：如何撤回自己在工作目录中的修改
		git restore 文件名
	2，暂存区：如何撤回自己的暂存
		git restore --staged 文件名
	3，版本库：如何撤回提交
		1，git commit --amend
			只是重新给用户一次机会该注释的机会
	    2，git restore -s HEAD~1 目标文件
	    	将目标文件回退到上一个版本
	   	4，git restore -s 版本hash值
	   		将目标文件退回到指定版本
	    

#30，git reflog
	获取所有head移动的信息，只要head移动过就会纪录


#31，reset
	1，git reset --soft HEAD~/hash值 撤销上一次提交的版本
	在运行git commit时，git会创建一个新的提交，并移动HEAD所指向的分支来使其指向该提交，使用git reset --soft使其回到版本时只是把分支移动到原来的位置，而不会改变索引和工作目录，也就是现在的工作区不变。再次commit时，会新开一个分支，然后分支和head一起移动到新的分支，旧的分叉会丢弃

	相当于回到了上一次的commit之前

	reset vs checkout：
	reset移动会HEAD和分支一起动，checkout只动HEAD不动分支

	如果要移动回来，可以先使用git reflog查看head移动的记录，然后使用soft移动到目标位置

	2，git reset [--mixed](默认值,可省略) HEAD~/hash值
	撤销提交和暂存区，相当于回到了上一次的add之前


	3，git reset --HARD HEAD~/hash值
	不仅回到了add前，还重置了工作区，和分支checkout类似，没被跟踪的文件也会被带过去，

	4，checkout和reset --hard的区别
		1，checkout只动head，后者动head和分支
		2，checkout对工作目录是安全的，如果当前工作区有更改，则不能切换成功，后者是强行切换，就会导致工作区内容丢失

	5，git reset [--mixed] [HEAD] filename：相当于将上一个提交中的filename文件覆盖当前暂存区的文件，不会影响其他文件。只有mixed可以操作路径，soft，hard不可以	


	6，git checkout 文件名
		只会动工作目录，用head里面的东西去覆盖动作目录


#32，数据恢复
	1，通过git reflog查找想要的分支，然后硬重置回去
		git log -g可以输出更多信息
	2，在想要硬重置回去的地方开一个分支
		git branch 分支名 hash值


#33，打tag
	git tag： 列出所有版本
	git tag -l 版本名：列出版本名后面的版本
	git tag 标签名：打tag
	git show 标签名：查看标签
	git tag -d 标签名：删除标签

#34，检出标签：
	git checkout -b 标签名：创建一个新的分支指向原标签
	如果不加-b会导致头部和内容分离，只能获取标签，标签对应的内容不能获取



///////////////////远程仓库////////////////////

#35，添加远程仓库：
	git remote add 后面网址的别名 https://github.com/Zengyujie/javase_code.git

#36，git remote -v
	查看仓库

#37，推送到远程
	git push 远程仓库别名 本地要推送的分支

#38，克隆仓库
	git clone url

#39，一次团队协作：
	1，初始化一个空的仓库，github上创建
	2，项目经理创建本地仓库
		1，git init
		2，将源码复制进来
		3，修改用户名和邮箱
		4，git add
		5，git commit
		6，git remote 别名 仓库url
		7，清理本地凭据
		8，git push 别名 分支 (输入用户名密码，推送完生成远程分支)
		9，项目经理邀请成员
		10，成员克隆远程分支
		git clone 仓库url （在本地生成.git文件，默认为远程仓库配了别名origin）
		11，成员修改
			git checkout -b dev(本地新建分支) origin/dev(远程跟踪分支)
			git branch origin/dev dev(建立dev分支与远程dev分支的连接，不然无法同步)
			
			执行自己的操作git add，commit...
			
			在push之前，以防其他人修改了导致上传冲突，首先git pull拉取最新内容，解决冲突后，commit，再push



#40，远程跟踪分支，远程分支，本地分支
	
	在push的时候就会生成远程跟踪分支(origin/master)

	只有在克隆的适合本地分支和远程跟踪分支有同步关系的


	git push 和 git fetch都是用于远程跟踪分支和远程分支的同步，并且只有当本地分支已经和远程分支建立连接之后，在本地分支使用push才会同步远程跟踪分支和远程分支。而fetch无论如何都需要merge的