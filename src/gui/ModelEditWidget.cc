#include <QtGui>

#include "transport/Node.hh"
#include "transport/Publisher.hh"

#include "gui/ModelEditWidget.hh"

using namespace gazebo;
using namespace gui;

ModelEditWidget::ModelEditWidget( QWidget *parent )
  : QWidget(parent)
{
  this->setWindowTitle("Gazebo: Model Edit");
  QVBoxLayout *mainLayout = new QVBoxLayout;

  this->treeWidget = new QTreeWidget();
  this->treeWidget->setColumnCount(1);
  this->treeWidget->setContextMenuPolicy( Qt::CustomContextMenu );
  //this->treeWidget->header()->hide();
  mainLayout->addWidget(this->treeWidget);

  this->setLayout(mainLayout);
  this->layout()->setContentsMargins(2,2,2,2);

  this->setSizePolicy( QSizePolicy::Fixed, QSizePolicy::Fixed );
}

ModelEditWidget::~ModelEditWidget()
{
}

void ModelEditWidget::showEvent(QShowEvent * /*_event*/)
{
  //this->sceneWidget->Init();
  //this->physicsWidget->Init();
}

void ModelEditWidget::closeEvent(QCloseEvent * /*_event*/)
{
}


ModelPropertyWidget::ModelPropertyWidget( QWidget *parent)
{
  QVBoxLayout *mainLayout = new QVBoxLayout;

  QHBoxLayout *nameLayout = new QHBoxLayout;
  QLabel *nameLabel = new QLabel(tr("Name:"));
  this->nameEdit = new QLineEdit;
  this->nameEdit->setFixedWidth(200);
  nameLayout->addWidget(nameLabel);
  nameLayout->addWidget(this->nameEdit);
  nameLayout->addItem(new QSpacerItem(20,20,QSizePolicy::Expanding, 
                                      QSizePolicy::Minimum));


  QHBoxLayout *staticLayout = new QHBoxLayout;
  QLabel *staticLabel = new QLabel(tr("Static:"));
  this->staticCheck = new QCheckBox;
  staticLayout->addWidget(staticLabel);
  staticLayout->addWidget(this->staticCheck);
  staticLayout->addItem(new QSpacerItem(40,20,QSizePolicy::Expanding, 
                                        QSizePolicy::Minimum));

  QHBoxLayout *xyzLayout = new QHBoxLayout;
  QLabel *xyzLabel = new QLabel(tr("XYZ:"));
  this->xEdit = new QLineEdit;
  this->xEdit->setValidator(new QDoubleValidator(this->xEdit) );
  this->xEdit->setFixedWidth(80);
  this->yEdit = new QLineEdit;
  this->yEdit->setValidator(new QDoubleValidator(this->yEdit) );
  this->yEdit->setFixedWidth(80);
  this->zEdit = new QLineEdit;
  this->zEdit->setValidator(new QDoubleValidator(this->zEdit) );
  this->zEdit->setFixedWidth(80);
  xyzLayout->addWidget( xyzLabel );
  xyzLayout->addWidget( this->xEdit );
  xyzLayout->addWidget( this->yEdit );
  xyzLayout->addWidget( this->zEdit );

  QHBoxLayout *rpyLayout = new QHBoxLayout;
  QLabel *rpyLabel = new QLabel(tr("RPY:"));
  this->rollEdit = new QLineEdit;
  this->rollEdit->setValidator(new QDoubleValidator(this->rollEdit) );
  this->rollEdit->setFixedWidth(80);
  this->pitchEdit = new QLineEdit;
  this->pitchEdit->setValidator(new QDoubleValidator(this->pitchEdit) );
  this->pitchEdit->setFixedWidth(80);
  this->yawEdit = new QLineEdit;
  this->yawEdit->setValidator(new QDoubleValidator(this->yawEdit) );
  this->yawEdit->setFixedWidth(80);
  rpyLayout->addWidget( rpyLabel );
  rpyLayout->addWidget( this->rollEdit );
  rpyLayout->addWidget( this->pitchEdit );
  rpyLayout->addWidget( this->yawEdit );

  QGroupBox *originBox = new QGroupBox( tr("Origin") );
  originBox->setStyleSheet(tr("QGroupBox{border: 1px solid black; padding-top: 2ex;}"));
  QVBoxLayout *originBoxLayout = new QVBoxLayout;
  originBox->setLayout(originBoxLayout);
  originBoxLayout->addLayout(xyzLayout);
  originBoxLayout->addLayout(rpyLayout);


  mainLayout->addLayout( nameLayout );
  mainLayout->addLayout( staticLayout );
  mainLayout->addWidget( originBox );

  this->setLayout(mainLayout);
  this->setSizePolicy( QSizePolicy::Fixed, QSizePolicy::Fixed );
}

ModelPropertyWidget::~ModelPropertyWidget()
{
}
