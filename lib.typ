/*The titlepage template is heavily inspired by the 'Red Agora' title page template: 
https://github.com/essmehdi/ensias-report-template/ */

#let titlepage(
  title: "", 
  subtitle: none, 
  authors: (),
  lecturer: "",
  course_name: "",
  course_code: "",
  programme: none,
  academic_year: none,
  school_logo: "resources/uva_logo_nl.svg",
) = {
  set line(length: 100%, stroke: 0.5pt)
  set table(stroke: none)

  // Display university logo
  block(
    height: 20%, width: 100%, 
    align(center + horizon)[#image(school_logo, width: 70%)]
  )

  // Title
  align(center)[
    #if subtitle != none {
      text(16pt, tracking: 2pt)[#smallcaps[#subtitle]]
    }
    #line()
    #if title != none {
      text(22pt, weight: "bold")[#title]
    }
    #line()
    #text(16pt)[#smallcaps[
      #datetime.today().display("[day] [month repr:long] [year]")
    ]]
  ]

  // Student, lecturer, course details
  h(1fr)
  grid(
    columns: (1fr, 1fr),
    grid.cell(align: left)[
      // Students
      #table(
        columns: (auto, auto),
        [*Student*], [*ID*],
        ..authors.map(author => (author.name, author.id)).flatten()
      )
    ],
    grid.cell(align: right)[
      // Lecturer
      #table(
        align: right,
        [*Lecturer*],
        lecturer
      )
      // Course
      #table(
        align: right,
        [*Course*],
        course_name,
        course_code,
      )
    ]
  )

  // Programme, academic year
  if (programme != none and academic_year != none) {
    align(center + bottom)[
      #programme \
      #text[Academic year: #academic_year]
    ]
  }
}


#let uva-report(
  body,
  abstract: "",
  title: "",
  subtitle: none,
  authors: (),
  lecturer: "",
  course_name: "",
  course_code: "",
  programme: none,
  academic_year: none,
  bibliography_path: none,
  school_logo: "resources/uva_logo_nl.svg",
  font: "Georgia",
  fontsize: 12pt,
) = {
  // Set document properties 
  set document(author: authors.map(elem => elem.name), title: title)

  // Display title page first with separate formatting
  titlepage(
    title: title,
    subtitle: subtitle,
    authors: authors,
    lecturer: lecturer,
    course_name: course_name,
    course_code: course_code,
    programme: programme,
    academic_year: academic_year,
    school_logo: school_logo,
  )

  let logo = image(school_logo, width: 60%)
  let header_title = {
    if subtitle != none {
      subtitle
    } else {
      title
    }
  }

  // Page setup
  set page(
    header: grid(
      columns: (auto, 1fr, auto),
      align: (left, center, right + top),
      box[#logo],
      h(1fr),
      text(size: 11pt, weight: 100)[#header_title]
    ),
    numbering: "1",
  )
  set heading(numbering: "1.")
  set par(justify: true)
  set text(font: font, size: fontsize)
  set figure(placement: none)

  // Make image caption font size small
  show figure.where(kind: image): it => {
    set text(size: 9pt)
    it
  }

  // Ensure level-1 headings start on a new page
  show heading.where(level: 1): it => {
    pagebreak()
    it
  }

  // Contents page: bold main sections, show level 2 indented
  set outline(depth: 2, indent: auto)
  show outline.entry.where(
    level: 1
  ): it => {
    v(12pt, weak: true)
    strong(it)
  }

  // Reset page counter to 1 and display abstract
  counter(page).update(1)
  {
    set par(justify: false)
    heading(outlined: false, numbering: none)[Abstract]
    abstract
  }

  // Show table of contents
  outline(depth: 2, indent: auto)

  body

  if bibliography_path != none {
    bibliography(bibliography_path)
  }
}
