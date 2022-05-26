
SELECT  rank, idcurso, idalumno, idactividad, nota, fechanota, elementocalificador
FROM 
(
SELECT  mdl_course.id AS idcurso, mdl_user.id AS idalumno, mdl_grade_grades.itemid as idActividad, ROUND(mdl_grade_grades.finalgrade,2) AS nota, 
DATE_ADD('1970-01-01', INTERVAL mdl_grade_grades.timemodified SECOND) AS fechanota,
    CASE 
    WHEN mdl_grade_items.itemtype = 'course' THEN concat('Total assignatura: ')
    WHEN mdl_grade_items.itemtype ='category' THEN mdl_grade_categories.fullname 
    ELSE mdl_grade_items.itemname
    END AS elementocalificador ,
    ROW_NUMBER() OVER (PARTITION BY idcurso, idactividad ORDER BY idcurso, idActividad, fechanota, nota desc) AS rank
    /*mdl_grade_items.sortorder*/
FROM mdl_course
    JOIN mdl_context ON mdl_course.id = mdl_context.instanceid
    JOIN mdl_role_assignments ON mdl_role_assignments.contextid = mdl_context.id
    JOIN mdl_user ON mdl_user.id = mdl_role_assignments.userid
    JOIN mdl_grade_grades ON mdl_grade_grades.userid = mdl_user.id
    JOIN mdl_grade_items ON mdl_grade_items.id = mdl_grade_grades.itemid
    left join mdl_grade_categories ON mdl_grade_categories.id = mdl_grade_items.iteminstance
    JOIN mdl_course_categories ON mdl_course_categories.id = mdl_course.category
    left join mdl_scale ON mdl_scale.id = mdl_grade_grades.rawscaleid
WHERE mdl_grade_items.courseid = mdl_course.id 
        AND mdl_grade_grades.finalgrade is not null 
        AND mdl_grade_items.hidden=0
        /*AND mdl_grade_items.itemtype <> 'course'*/
        AND mdl_grade_items.itemtype = 'mod'
        AND mdl_course.id IN (2,4) 
        ) AS X
 WHERE rank <= 5

